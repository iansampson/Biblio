//
//  File.swift
//  
//
//  Created by Ian Sampson on 2021-11-17.
//

import Foundation
import SwiftSoup
import LetterCase

enum ParseError: Error {
    case failedToConvertDataToString
    case expectedHeadSectionInHTML(String)
}

extension HTML {
    static func parse(_ html: Data, from url: URL) throws -> Metadata.Result {
        guard let html = String(bytes: html, encoding: .utf8) else {
            throw ParseError.failedToConvertDataToString
        }
        return try parse(html, from: url)
    }
    
    static func parse(_ html: String, from url: URL) throws -> Metadata.Result {
        let document = try SwiftSoup.parse(html)
        guard let head = document.head() else {
            throw ParseError.expectedHeadSectionInHTML(html)
            // TODO: Throw error
        }
        
        func coverImageURL(in document: Document) throws -> URL? {
            for img in try document.select("img") {
                // fb-featured-image at-coverimage
                // fb-featured-image (x2) book-info__cover-img
                // class =
                // TODO: Search for other types of issue image as well
                let id = try img.attr("id").lowerCased()
                let `class` = try img.attr("class").lowerCased()
                
                if id == "issueimage" || id == "bookimage" || `class` == "cover" || `class` == "book__image" {
                    let source = try img.attr("src")
                    guard var urlComponents = URLComponents(string: source) else {
                        return nil
                    }
                    if urlComponents.scheme == nil {
                        urlComponents.scheme = "https"
                    }
                    return urlComponents.url
                    // TODO: Convert from base64-encoded data to image
                }
            }
            return nil
        }
        
        func isbn(in document: Document) throws -> String? {
            // TODO: Only do this for Springer sites ...
            for span in try document.select("span") {
                if span.id() == "print-isbn" {
                    return try span.text()
                }
                // TODO: Handle "electronic-isbn"
            }
            
            for division in try document.select("div") {
                if try division.classNames().contains("book-eisbn") {
                    let string = try division.text().components(separatedBy: .whitespaces).filter {
                        for character in $0 {
                            if character.isLetter && character != "x" {
                                return false
                            }
                        }
                        return true
                    }.first
                    if let string = string {
                        return string
                    }
                }
            }
            
            return nil
        }
        
        func containerLink(in document: Document) throws -> URL? {
            // Cambridge UP
            for link in try document.select("a") {
                if try link.classNames().contains("book__title") {
                    let destination = try link.attr("href")
                    return URL(string: destination, relativeTo: url)
                }
            }
            return nil
        }
        
        var citation: [HTML.Metadata.Citation.Key: [String]] = [:]
        var openGraph = HTML.Metadata.OpenGraph()
        
        try head.children().filter { $0.tagName() == "meta" }.forEach { tag in
            let name = try tag.attr("name")
            
            if name.hasPrefix(HTML.Metadata.Prefix.citation) {
                let stringKey = String(name[HTML.Metadata.Prefix.citation.endIndex...])
                    .convert(from: .snake, to: .lowerCamel)
                guard let key = HTML.Metadata.Citation.Key(rawValue: stringKey) else {
                    return
                }
                let content = try tag.attr("content")
                if citation[key] == nil {
                    citation[key] = [content]
                } else {
                    citation[key]?.append(content)
                }
            }
            
            let property = try tag.attr("property")
            let content = try tag.attr("content")
            if !property.isEmpty {
                openGraph.appendContent(content, forKey: property)
            }
        }
        
        return .init(citation: citation,
                     openGraph: openGraph,
                     isbn: try isbn(in: document),
                     coverImageURL: try coverImageURL(in: document),
                     containerLink: try containerLink(in: document))
        // TODO: Consider making citation optional if all properties are nil
    }

}

enum HTML {
    enum Metadata {
        enum Prefix {
            static let openGraph = "og:"
            static let citation = "citation_"
        }
        
        struct Result {
            let citation:[Metadata.Citation.Key: [String]]
            let openGraph: OpenGraph
            let isbn: String? // TODO: Handle variant ISBNs
            let coverImageURL: URL?
            let containerLink: URL?
        }
        
        struct OpenGraph: KeySubscriptable {
            var storage: [Key: [String]] = [:]
            
            var image = Image()
            var article = Article()
            var book = Book()
            var books = Books()
            
            mutating func appendContent(_ content: String, forKey key: String) {
                if let key = Key(prefixedString: key) {
                    appendContent(content, forKey: key)
                }
                
                else if let key = Image.Key(prefixedString: key) {
                    image.appendContent(content, forKey: key)
                }
                
                else if let key = Article.Key(prefixedString: key) {
                    article.appendContent(content, forKey: key)
                }
                
                else if let key = Book.Key(prefixedString: key) {
                    book.appendContent(content, forKey: key)
                }
                
                else if let key = Books.Key(prefixedString: key) {
                    books.appendContent(content, forKey: key)
                }
            }
            
            subscript(key: Key) -> [String] {
                storage[key] ?? []
            }
            
            struct Article: KeySubscriptable {
                var storage: [Key: [String]] = [:]
                
                enum Key: String, PrefixableKey {
                    static let prefix = "article:"
                    
                    case publishedTime
                    case modifiedTime
                    case expirationTime
                    case author
                    case section
                    case tag
                }
            }
            
            struct Book: KeySubscriptable {
                var storage: [Key: [String]] = [:]
                
                enum Key: String, PrefixableKey {
                    static let prefix = "book:"
                    
                    case author
                    case isbn
                    case releaseDate
                    case tag
                }
            }
            
            struct Books: KeySubscriptable {
                var storage: [Key: [String]] = [:]
                
                enum Key: String, PrefixableKey {
                    static let prefix = "books:"
                    
                    case author
                    case genre
                    case initialReleaseDate
                    case isbn
                    case language
                    case pageCount
                    case rating
                    case releaseDate
                    case sample
                }
            }
            
            struct Image: KeySubscriptable {
                var storage: [Key: [String]] = [:]
                
                enum Key: String, PrefixableKey {
                    static let prefix = "image:"
                    
                    case url
                    case secureUrl
                    case type
                    case width
                    case height
                    case alt
                }
            }
            
            enum Key: String, PrefixableKey {
                static let prefix = "og:"
                
                case title
                case type
                case image
                case url
                
                case audio
                case description
                case determiner
                case locale
                case alternateLocale = "localealternate" // "locale:alternate"
                case siteName
                case video
                
                case author
                case publishedTime
            }
        }
        
        struct Citation {
            enum Key: String {
                case author
                case authors
                case authorOrcid
                case dissertationInstitution
                case title
                case year
                case date
                case onlineDate
                case publicationDate
                case dissertationName
                case language
                case id
                case doi
                case pmid
                case mjid
                case idFromSassPath
                case patentNumber
                case publisher
                case technicalReportInstitution
                case journalTitle
                case abbreviatedJournalTitle = "journalAbbrev"
                case conferenceTitle
                case inbookTitle
                case issn
                case isbn
                case volume
                case issue
                case section
                case firstPage = "firstpage"
                case lastPage = "lastPage"
                case keywords
                case fulltextWorldReadable
                case publicUrl
                case pdfUrl
                case xmlUrl
                case fulltextHtmlUrl
                case abstractHtmlUrl
                case abstractPdfUrl
                case collectionId
                case price
                case patentCountry
                case reference
            }
        }
    }
    
    /*struct Citation {
        var author: String?
        var authors: String?
        var title: String?
        var firstPage: String?
        var lastPage: String?
        var doi: String?
        var journalTitle: String?
        var abbreviatedJournalTitle: String?
        var volume: String? // Int?
        var issue: String? // Int?
        var publicationDate: String? // Date format?
        var issn: String?
        var isbn: String?
        var publisher: String?
        var pdfURL: URL?
        var xmlURL: URL?
    }*/
}

protocol KeySubscriptable {
    associatedtype Key: Hashable
    var storage: [Key: [String]] { get set }
}

extension KeySubscriptable {
    public subscript(key: Key) -> [String] {
        storage[key] ?? []
    }
}

extension KeySubscriptable {
    mutating func appendContent(_ content: String, forKey key: Key) {
        if storage[key] == nil {
            storage[key] = [content]
        } else {
            storage[key]?.append(content)
        }
    }
}


protocol PrefixableKey: RawRepresentable where RawValue == String {
    static var prefix: String { get }
}

extension PrefixableKey {
    init?(prefixedString string: String) {
        if string.hasPrefix(Self.prefix) {
            let truncatedString = String(string[(Self.prefix).endIndex...])
                .convert(from: .snake, to: .lowerCamel)
            self.init(rawValue: truncatedString)
        } else {
            return nil
        }
    }
}

// TODO: Extract cover images from a broader range of publisher websites
// TODO: Support other forms of metadata besides "citation_"

// - [x] Handle multiple values for each metadata key
// - [x] Extract ISBN and other identifies

/*
 The complete list of valid object og:type values is: article, book, books.author, books.book, books.genre, business.business, fitness.course, game.achievement, music.album, music.playlist, music.radio_station, music.song, place, product, product.group, product.item, profile, restaurant.menu, restaurant.menu_item, restaurant.menu_section, restaurant.restaurant, video.episode, video.movie, video.other, video.tv_show.
 
 // Make an enum of these values.
 */

extension HTML {
    static func redirectURL(in html: String) throws -> URL? {
        let document = try SwiftSoup.parse(html)
        
        guard let head = document.head() else {
            return nil
        }
        
        let content: String? = try head.children().compactMap {
            guard try $0.attr("http-equiv").lowercased() == "refresh",
                  $0.tagName() == "meta"
            else {
                return nil
            }
            return try $0.attr("content")
        }.first
        
        guard let content = content else {
            return nil
        }
        
        let substrings = content.split(separator: ";")
        
        guard let integer = substrings.first
                .map(String.init)
                .flatMap(Int.init),
              integer > 0,
              let secondSubstring = substrings.dropFirst().first?
                .trimmingCharacters(in: .whitespacesAndNewlines),
              secondSubstring.hasPrefix("url=\'"),
              secondSubstring.hasSuffix("'")
        else {
            return nil
        }
        
        let containerUrl = secondSubstring["url=\'".endIndex...].dropLast()
        guard let httpRange = containerUrl.range(of: "http"),
              let urlString = containerUrl[httpRange.lowerBound...]
                .removingPercentEncoding
        else {
            return nil
        }
        
        return URL(string: urlString)
    }
}
