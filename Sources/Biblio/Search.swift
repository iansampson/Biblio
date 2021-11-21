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
    
    func instance(withISBN isbn: String) async throws -> Instance? {
        let libraryOfCongress = LinkedDataService(urlSession: urlSession)
        guard let bibframeInstanceURL = try await libraryOfCongress.search(isbn, count: 1).first?.url else {
            return nil
        }
        let bibframeInstance = try await libraryOfCongress.instance(atURL: bibframeInstanceURL)
        let googleVolume = try await GoogleBooks(urlSession: urlSession).search(for: isbn, field: .isbn).items.first
        let bibframeWork = try await libraryOfCongress.work(for: bibframeInstance)
        var instance = Instance(instance: bibframeInstance, work: bibframeWork)
        if let googleVolume = googleVolume {
            instance.merge(googleVolume)
        }
        return instance
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

// Search

// Find an article by DOI
// and retrieve all the relevant metadata

// LibraryOfCongress + GoogleBooks (for images)
