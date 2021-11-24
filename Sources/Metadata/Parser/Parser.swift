//
//  Parser.swift
//  
//
//  Created by Ian Sampson on 2021-11-18.
//

import Foundation
import DOI
import ISBN

struct MetadataParser {
    // TODO: Consider renaming to MetadataMap
    // (or at least naming the property that)
    typealias Image = Metadata.Image
    
    struct Map {
        var properties: [String: [String]] = [:]
        var names: [String: [String]] = [:]
        
        subscript(_ key: OpenGraph.Key) -> [String] {
            properties[key.rawValue] ?? []
        }
        
        subscript(_ key: HighwirePress.Citation.Key) -> [String] {
            names[key.rawValue] ?? []
        }
        
        mutating func insert(_ node: Document.Node) {
            guard node.name == "meta" else {
                return
            }
            
            if let content = node.attributes["content"] {
                if let property = node.attributes["property"] {
                    properties.append(content, forKey: property)
                } else if let name = node.attributes["name"] {
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
    
    /*func _parse(data: Data, from url: URL) throws -> Metadata {
        guard var remainingInput = String(bytes: data, encoding: .utf8)?[...] else {
            fatalError()
            // TODO: Throw error
        }
        
        while let character = remainingInput.popFirst() {
            
        }
    }*/
    
    func parse(_ data: Data, from url: URL) throws -> Metadata {
        let document = try Document(data)
        guard let head = document.head,
              let body = document.body
        else {
            throw ParseError.htmlDocumentIsMissingHead
        }
        
        func appendIdentifier(_ string: String, to metadata: inout Metadata) {
            // TOOD: Ensure uniqueness
            let identifier: Metadata.Identifier
            if let doi = try? DOI(string) {
                identifier = .doi(doi)
            } else if let isbn = try? ISBN(string) {
                identifier = .isbn(isbn)
            } else {
                return
            }
            
            if !metadata.identifiers.contains(identifier) {
                metadata.identifiers.append(identifier)
            }
        }
        
        let map = head.children.reduce(into: Map()) { (map, element) in
            map.insert(element)
        }
        
        var context = Context(url: url)
        let parse = body.events.reduce(into: Metadata(url: url, map: map)) { (metadata, event) in
            switch event {
            case let .openNode(node):
                context.ids.append(node.attributes["id"] ?? "")
                context.classes.append(node.attributes["class"] ?? "")
                
                if let image = Image(node, context: context) {
                    metadata.images.append(image)
                }
                
                else if let text = node.text { // ?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    appendIdentifier(text, to: &metadata)
                }
                
                else {
                    for attribute in node.attributes {
                        // TODO: Handle attributes with multiple values
                        appendIdentifier(attribute.value, to: &metadata)
                    }
                }
                
                /*else if let isbn = Metadata._ISBN(node) {
                    parse.isbns.append(isbn)
                }*/
            case .closeNode:
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
