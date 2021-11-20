//
//  MetadataParser.swift
//  
//
//  Created by Ian Sampson on 2021-11-18.
//

import Foundation

struct MetadataParser {
    struct Parse {
        let url: URL
        var isbns: [ISBN]
        var images: [Image]
        
        init(url: URL, map: Map) {
            self.url = url
            isbns = map[.booksISBN].map(ISBN.init) + map[.bookISBN].map(ISBN.init) + map[.isbn].map(ISBN.init)
            // TODO: Abtstract this function into an initializer or property on Map
            // self.images = map.images
            self.images = []
        }
    }
    
    // TODO: Consider renaming to MetadataMap
    // (or at least naming the property that)
    struct Map {
        var properties: [String: [String]] = [:]
        var names: [String: [String]] = [:]
        
        subscript(_ key: OpenGraph.Key) -> [String] {
            properties[key.rawValue] ?? []
        }
        
        subscript(_ key: HighwirePress.Citation.Key) -> [String] {
            names[key.rawValue] ?? []
        }
        
        mutating func insert(_ element: HTMLDocument.Element) {
            guard element.name == "meta" else {
                return
            }
            
            if let content = element.attributes["content"] {
                if let property = element.attributes["property"] {
                    properties.append(content, forKey: property)
                } else if let name = element.attributes["name"] {
                    names.append(content, forKey: name)
                }
            }
        }
        
        func images(forKey key: OpenGraph.Key) -> [Image] {
            self[key].lazy.compactMap(URL.init).map { Image(tag: key.rawValue, url: $0) }
        }
        
        var images: [Image] {
            images(forKey: .imageSecureURL) + images(forKey: .imageURL) + images(forKey: .image)
        }
    }
    
    enum ParseError: Error {
        case htmlDocumentIsMissingHead
    }
    
    struct Context {
        let url: URL
        var ids: [String] = []
        var classes: [String] = []
    }
    
    func parse(_ data: Data, from url: URL) throws -> Parse {
        let document = try HTMLDocument(data)
        guard let head = document.head,
              let body = document.body
        else {
            throw ParseError.htmlDocumentIsMissingHead
        }

        let map = head.children.reduce(into: Map()) { (map, element) in
            map.insert(element)
        }
        
        var context = Context(url: url)
        let parse = body.events.reduce(into: Parse(url: url, map: map)) { (parse, event) in
            switch event {
            case let .openElement(element):
                context.ids.append(element.attributes["id"] ?? "")
                context.classes.append(element.attributes["class"] ?? "")
                
                if let image = Image(element, context: context) {
                    parse.images.append(image)
                } else if let isbn = ISBN(element) {
                    parse.isbns.append(isbn)
                }
            case .closeElement:
                context.ids.removeLast()
                context.classes.removeLast()
            }
        }
            
        return parse
    }
}

extension Dictionary where Value: ExpressibleByArrayLiteral, Value: RangeReplaceableCollection, Value.Element == Value.ArrayLiteralElement {
    mutating func append(_ element: Value.Element, forKey key: Key) {
        if self[key] == nil {
            self[key] = [element]
        } else {
            self[key]?.append(element)
        }
    }
}
