//
//  CrossRef.swift
//  CrossRef
//
//  Created by Ian Sampson on 2021-09-03.
//

import Foundation
import LetterCase

public final class CrossRef {
    let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}

extension CrossRef {
    private static let works = "https://api.crossref.org/works"
    
    public func search(_ query: String) async throws -> Response {
        // Construct URL
        var components = URLComponents(string: CrossRef.works)!
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            // URLQueryItem(name: "key", value: apiKey)
        ]
        let url = components.url!
        
        // Request data
        let (data, _) = try await urlSession.data(from: url)
        
        // Decode data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromKebabCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Response.self, from: data)
    }
    
    public struct Response: Codable {
        public let message: Message
        
        public struct Message: Codable {
            public let totalResults: Int
            public let items: [Item]?
        }
    }
}
