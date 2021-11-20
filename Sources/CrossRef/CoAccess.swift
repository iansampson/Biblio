//
//  CoAccess.swift
//  
//
//  Created by Ian Sampson on 2021-11-17.
//

import Foundation

// (Data, Response)
// DOI(url: URL) ->

public enum CoAccess {
    public struct Deposit: Codable {
        public let isbn: [String]?
        public let prefix: String?
        public let author: [String]?
        public let containerTitle: String?
        public let issn: [String]?
        public let host: String?
        public let publisher: String?
        public let title: String?
        public let relations: [Relation]?
        public let url: URL?
        public let doi: String?
        
        /*enum CodingKeys: String, CodingKey {
            case isbn = "ISBN"
            case prefix = "prefix"
            case author = "author"
            case containerTitle = "container-title"
            case issn = "ISSN"
            case host = "host"
            case publisher = "publisher"
            case title = "title"
            case relations = "relations"
            case url = "url"
            case doi = "doi"
        }*/
        
        public struct Relation: Codable {
            public let identifier: String
            public let prefix: String
            public let host: String
            public let url: URL
        }
    }
    
    public struct Reference {
        let htmlURL: URL
        
        public init?(htmlURL: URL) {
            guard htmlURL.host == "apps.crossref.org",
                  htmlURL.pathComponents == ["/", "coaccess", "coaccess.html"]
            else {
                return nil
            }
            
            self.htmlURL = htmlURL
        }
        
        public var jsonUrl: URL {
            guard var urlComponents = URLComponents(string: "https://apps.crossref.org/search/coaccess") else {
                fatalError()
            }
            urlComponents.query = htmlURL.query?.removingPercentEncoding
            
            guard let url = urlComponents.url else {
                fatalError()
            }
            
            return url
        }
    }
}
