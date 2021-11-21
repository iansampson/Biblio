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
    func instance(withISBN isbn: String) async throws -> Instance? {
        let libraryOfCongress = LinkedDataService(urlSession: urlSession)
        let googleBooks = GoogleBooks(urlSession: urlSession)
        
        return try await withThrowingTaskGroup(of: IntermediateResult?.self) { taskGroup in
            taskGroup.addTask {
                guard let url = try await libraryOfCongress.search(isbn, count: 1).first?.url else {
                    return nil
                }
                let instance = try await libraryOfCongress.instance(atURL: url)
                let work = try await libraryOfCongress.work(for: instance)
                return .bibframeInstanceAndWork(instance, work)
            }
            
            taskGroup.addTask {
                guard let googleVolume = try await googleBooks.search(for: isbn, field:  .isbn).items.first else {
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
    
    func instance(withDOI doi: String) async throws -> Instance? {
        let crossRef = CrossRef.Service(urlSession: urlSession)
        guard let work = try await crossRef.work(withDOI: doi) else {
            return nil
        }
        var instance = Instance(work)
        for try await metadata in MetadataCrawler(urlSession: urlSession).metadata(atURL: work.url) {
            instance.merge(metadata)
        }
        return instance
        // TODO: Construct URL with DOI and search earlier (i.e. in parallel)
    }
}

struct DOI {
    let string: String
    
    var url: URL {
        guard let url = URL(string: "https://doi.org/")?.appendingPathComponent(string) else {
            fatalError()
        }
        return url
    }
}

// Search

// Find an article by DOI
// and retrieve all the relevant metadata

// LibraryOfCongress + GoogleBooks (for images)
