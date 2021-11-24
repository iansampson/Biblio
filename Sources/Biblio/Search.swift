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
    
    public init(urlSession: URLSession) {
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
    public func instance(withISBN isbn: ISBN) async throws -> Instance? {
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
    
    public func instance(withDOI doi: DOI) async throws -> Instance? {
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
    
    // a stream of asynchronous values
    // *within* that stream we want to kick off a bunch more
    // we don’t want to wait for each item in the stream
    // or rather, we don’t want to pause execution
    // when we receive each of those values
    // (Really we’re into Combine territory here,
    // flatMapping each of these publishers).
    // When we get a Metadata result,
    // we want to fire off another request
    // for each (unique) item in the result.
    
    // Retrieves metadata for a webpage at the given URL
    // TODO: Return an async stream
    // TODO: Run searches in parallel
    public typealias InstanceStream = AsyncFlatMapSequence<TaskStream<Metadata>,
                                                            AsyncCompactMapSequence<TaskStream<Instance?>, Instance>>
    
    // func instancesFromWebPage(at url: URL)
    // func instancesFromHTML(at url: URL)
    public func instancesFromHTML(atURL url: URL) async throws -> InstanceStream {
        MetadataCrawler(urlSession: urlSession)
            .metadata(atURL: url)
            .flatMap { metadata in
                TaskStream(metadata.identifiers) { [weak self] identifier -> Instance? in
                    switch identifier {
                    case .isbn(let isbn):
                        return try? await self?.instance(withISBN: isbn)
                    case .doi(let doi):
                        return try? await self?.instance(withDOI: doi)
                    }
                }
                .compactMap { instance -> Instance? in
                    var instance = instance
                    instance?.merge(metadata)
                    return instance
                }
            }
    }
}

// TODO: Decide how to select which ISBN is the most relevant
// TODO: Submit requests in parallel
// TODO: Handle DOIs, ISSNs, etc.
// TODO: Careful not to kick off an infinite loop
// (i.e. do not call this function from instance(withDOI:)
