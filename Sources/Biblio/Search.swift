//
//  Search.swift
//  
//
//  Created by Ian Sampson on 2021-11-20.
//

import Foundation
import LibraryOfCongress
import GoogleBooks
import CrossRef
import Metadata
import DOI
import ISBN

final class Service {
    let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    // TODO: Consider returning a stream of Instances as the updates roll in
    /*func instance(withISBN isbn: String) async throws -> Instance? {
        let libraryOfCongress = LinkedDataService(urlSession: urlSession)
        async let bibframeInstance = libraryOfCongress.instance(withID: isbn)
        async let googleVolume = GoogleBooks(urlSession: urlSession).search(for: isbn, field: .isbn).items.first
        let bibframeWork = try await libraryOfCongress.work(for: bibframeInstance)
        var instance = try await Instance(instance: bibframeInstance, work: bibframeWork)
        if let googleVolume = try await googleVolume {
            instance.merge(googleVolume)
        }
        return instance
    }*/
    
    enum IntermediateResult {
        case bibframeInstanceAndWork(LibraryOfCongress.Instance, LibraryOfCongress.Work)
        case googleVolume(GoogleVolume)
    }
    
    // ISBN -> SearchResults -> Instance -> Work
    func instance(withISBN isbn: ISBN) async throws -> Instance? {
        let libraryOfCongress = LinkedDataService(urlSession: urlSession)
        let googleBooks = GoogleBooks(urlSession: urlSession)
        
        return try await withThrowingTaskGroup(of: IntermediateResult?.self) { taskGroup in
            taskGroup.addTask {
                guard let url = try await libraryOfCongress
                        .search(isbn.string(format: .isbn13, hyphenated: false)!, count: 1)
                        .first?.url
                else {
                    return nil
                }
                let instance = try await libraryOfCongress.instance(atURL: url)
                let work = try await libraryOfCongress.work(for: instance)
                return .bibframeInstanceAndWork(instance, work)
            }
            
            taskGroup.addTask {
                guard let googleVolume = try await googleBooks
                        .search(for: isbn.string(format: .isbn13, hyphenated: false)!, field:  .isbn)
                        .items.first else {
                    return nil
                }
                return .googleVolume(googleVolume)
            }
            
            var googleVolume: GoogleVolume?
            var instance: Instance?
            for try await result in taskGroup {
                switch result {
                case let .bibframeInstanceAndWork(bibframeInstance, bibframeWork):
                    instance = .init(instance: bibframeInstance, work: bibframeWork)
                case let .googleVolume(volume):
                    googleVolume = volume
                case .none:
                    break
                }
            }
            
            if let googleVolume = googleVolume {
                instance?.merge(googleVolume)
            }
            
            return instance
        }
    }
    
    func instance(withDOI doi: DOI) async throws -> Instance? {
        let crossRef = CrossRef.Service(urlSession: urlSession)
        async let work = crossRef.work(withDOI: doi.string)
        
        var instance: Instance?
        for try await metadata in MetadataCrawler(urlSession: urlSession).metadata(atURL: doi.url) {
            if instance == nil {
                guard let work = try await work else {
                    return nil
                }
                instance = .init(work)
            }
            instance?.merge(metadata)
        }
        
        return instance
        // TODO: Construct URL with DOI and search earlier (i.e. in parallel)
    }
    
    // Retrieves metadata for a webpage at the given URL
    // TODO: Return an async stream
    // TODO: Run searches in parallel
    func instances(atURL url: URL) async throws -> [Instance] {
        var instances: [Instance] = []
        for try await metadata in MetadataCrawler(urlSession: urlSession).metadata(atURL: url) {
            for identifier in metadata.identifiers {
                switch identifier {
                case .isbn(let isbn):
                    if var instance = try? await instance(withISBN: isbn)
                    {
                        instance.merge(metadata)
                        instances.append(instance)
                    }
                case .doi(let doi):
                    if var instance = try? await instance(withDOI: doi) {
                        instance.merge(metadata)
                        instances.append(instance)
                    }
                }
            }
            // TODO: Decide how to select which ISBN is the most relevant
            // TODO: Submit requests in parallel
            // TODO: Handle DOIs, ISSNs, etc.
            // TODO: Careful not to kick off an infinite loop
            // (i.e. do not call this function from instance(withDOI:)
        }
        return instances
    }
}

// Search

// Find an article by DOI
// and retrieve all the relevant metadata

// LibraryOfCongress + GoogleBooks (for images)
