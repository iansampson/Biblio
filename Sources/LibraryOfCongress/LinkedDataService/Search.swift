//
//  Search.swift
//  
//
//  Created by Ian Sampson on 2021-11-13.
//

import Foundation
import FeedKit

// TODO: Consider initializing as an object with a given URLSession
public enum LinkedDataService {
    public struct SearchResult {
        public let title: String
        public let url: URL
        // dateModified: Date
        // id: String
    }
    
    /// Searches the Library of Congress Linked Data Service and returns an array of results.
    public static func search(_ query: String, count: Int? = nil) async throws -> [SearchResult] {
        guard var components = URLComponents(string: "https://id.loc.gov/search/") else {
            fatalError()
        }
        
        components.queryItems = [
            .init(name: "q", value: query),
            .init(name: "format", value: "atom"),
        ]
        
        if let count = count {
            components.queryItems?.append(.init(name: "count", value: String(count)))
        }
        
        guard let url = components.url else {
            fatalError()
            // TODO: Throw an error instead
        }
        
        // TODO: Inject URLSession dependency
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = FeedParser(data: data).parse()
        
        switch result {
        case let .success(feed):
            guard let feed = feed.atomFeed,
                  let entries = feed.entries
            else {
                return []
                // TODO: Throw an error instead
            }
            
            return entries.compactMap { entry -> SearchResult? in
                let url = entry.links?.compactMap { links -> URL? in
                    guard let attributes = links.attributes,
                          let type = attributes.type,
                          type == "application/json",
                          let href = attributes.href,
                          let url = URL(string: href)?.secure
                    else {
                        return nil
                    }
                    
                    return url
                }
                .first
                
                guard let url = url else {
                    return nil
                }
                
                return SearchResult(title: entry.title ?? "",
                                    url: url)
            }
            
        case let .failure(error):
            throw error
        }
    }
}

// TODO: Consider using Suggest2 API for auto-completions
