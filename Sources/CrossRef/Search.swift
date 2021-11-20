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

public enum SearchableWorkType: String {
    case chapter = "Chapter"
    case journalArticle = "Journal+Article"
    case other = "Other"
    case book = "Book"
    case conferencePaper = "Conference+Paper"
    case monograph = "Monograph"
    case dataset = "Dataset"
    case component = "Component"
    case entry = "Entry"
    case report = "Report"
}

extension CrossRef {
    private static let works = "https://api.crossref.org/works"
    
    public func search(_ query: String, type: WorkType? = nil) async throws -> WorksMessage {
        // Construct URL
        var components = URLComponents(string: CrossRef.works)!
        components.queryItems = [
            .init(name: "query", value: query)
        ]
        if let type = type {
            let typeID = type.rawValue.convert(from: .lowerCamel, to: .kebab)
            components.queryItems?.append(.init(name: "filter", value: "type:\(typeID)"))
        }
        
        let url = components.url!
        
        // Request data
        let (data, response) = try await urlSession.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError.init(.badServerResponse)
            // TODO: Throw a custom error here and include message from the server
        }
        
        // Decode data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromKebabCase
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode(WorksMessage.self, from: data)
    }
}
