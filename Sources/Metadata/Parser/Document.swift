//
//  Document.swift
//  
//
//  Created by Ian Sampson on 2021-11-18.
//

import Foundation
import SwiftSoup
import XML

struct Document {
    private let base: SwiftSoup.Document
    
    var html: Node {
        .init(base)
    }
    
    var head: Node? {
        base.head().map(Node.init)
    }
    
    var body: Node? {
        base.body().map(Node.init)
    }
    
    struct Node {
        private let base: SwiftSoup.Node
        
        // TODO: Consider packing name, attributes, and text
        // into an enum
        
        var name: String? {
            if let element = base as? Element {
                return element.tagName()
            } else {
                return nil
            }
        }
        
        var attributes: Attributes {
            .init(base: base.getAttributes())
        }
        
        var text: String? {
            if let textNode = base as? TextNode {
                return textNode.text()
            } else {
                return nil
            }
        }
        
        // typealias Elements = LazyMapSequence<LazySequence<SwiftSoup.Elements>.Elements, Document.Node>
        
        var children: [Node] {
            base.getChildNodes().map(Node.init)
        }
        
        fileprivate init(_ node: SwiftSoup.Node) {
            base = node
        }
    }
    
    struct Attribute {
        let key: String
        let value: String
    }
    
    struct Attributes: Sequence {
        fileprivate let base: SwiftSoup.Attributes?
        
        // Optional<LazyMapSequence<Attributes, Document.Attribute>.Iterator>
        // typealias Iterator = LazyMapSequence<Attributes, Document.Attribute>.Iterator
        func makeIterator() -> Iterator {
            .init(base: base?.makeIterator())
        }
        
        struct Iterator: IteratorProtocol {
            fileprivate var base: SwiftSoup.Attributes.Iterator?
            
            func next() -> Attribute? {
                guard let baseAttribute = base?.next() else {
                    return nil
                }
                return Attribute(key: baseAttribute.getKey(),
                                 value: baseAttribute.getValue())
            }
        }
        
        subscript(key: String) -> String? {
            if let value = base?.get(key: key),
               !value.isEmpty {
                return value
            } else {
                return nil
            }
        }
    }
    
    enum Event {
        case openNode(Node)
        case closeNode(Node)
        
        // open element
        // close element
        // content
    }
    
    struct EventSequence: Sequence {
        let node: Node
        func makeIterator() -> EventIterator {
            EventIterator(node: node)
        }
    }
    
    final class EventIterator: IteratorProtocol {
        let node: Document.Node
        var iterator: Array<Document.Node>.Iterator? = nil
        var childIterator: EventIterator? = nil
        var elementIsClosed = false
        
        init(node: Document.Node) {
            self.node = node
        }
        
        func next() -> Event? {
            if elementIsClosed {
                return nil
            }
            
            else if iterator == nil {
                self.iterator = node.children.makeIterator()
                return .openNode(node)
            }
            
            while true {
                if let event = childIterator?.next() {
                    return event
                } else {
                    if let childIterator = iterator?.next().map(EventIterator.init(node:)) {
                        self.childIterator = childIterator
                    } else {
                        elementIsClosed = true
                        return .closeNode(node)
                    }
                }
            }
        }
    }
    
    init(_ data: Data) throws {
        let string = String(bytes: data, encoding: .utf8)!
        base = try SwiftSoup.parse(string)
    }
}

extension Document.Node {
    var events: Document.EventSequence {
        .init(node: self)
    }
}
