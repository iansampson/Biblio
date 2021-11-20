//
//  Biblio.swift
//  
//
//  Created by Ian Sampson on 2021-11-13.
//

import Foundation
import GoogleBooks
import LibraryOfCongress

public final class Library {
    let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    // TODO: Unify search API across modules
    // submit(_), search(_), search(for:)
    public func search(for query: String) async throws -> [Instance] {
        // TODO: Use a publisher to deliver results asynchronously
        let googleBooks = GoogleBooks(urlSession: urlSession)
        let googleBooksResponse = try await googleBooks.search(query)
        let libraryOfCongress = LinkedDataService(urlSession: urlSession)
        
        var instances: [Instance] = []
        // TODO: Run searches in parallel and update date asynchronously
        for googleVolume in googleBooksResponse.items {
            let isbn: String? = googleVolume.volumeInfo.industryIdentifiers?.compactMap { volume -> String? in
                guard let type = GoogleVolume.IdentifierType(rawValue: volume.type) else {
                    return nil
                }
                
                switch type {
                case .isbn10, .isbn13:
                    return volume.identifier
                }
            }.first
            
            guard let isbn = isbn else {
                continue
            }
            
            if let result = try await libraryOfCongress.search(isbn).first {
                let bibframeInstance = try await libraryOfCongress.instance(atURL: result.url)
                let bibframeWork = try await libraryOfCongress.work(for: bibframeInstance)
                let instance = Instance(sources: .init(googleVolume: googleVolume,
                                                       libraryOfCongress: .init(instance: bibframeInstance,
                                                                                work: bibframeWork)))
                instances.append(instance)
            }
            // TODO: Specify type as instance
        }
        
        return instances
    }
}

// That’s a lot of work (and time) for *every* query item.
// Why not just look them up after the user selects one?
