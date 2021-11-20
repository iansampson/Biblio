//
//  Document.swift
//  
//
//  Created by Ian Sampson on 2021-11-18.
//

import Foundation
import SwiftSoup

struct Document {
    private let base: SwiftSoup.Document
    
    var html: Element {
        .init(base)
    }
    
    var head: Element? {
        base.head().map(Element.init)
    }
    
    var body: Element? {
        base.body().map(Element.init)
    }
    
    struct Element {
        private let base: SwiftSoup.Element
        
        var name: String {
            base.tagName()
        }
        
        var attributes: Attributes {
            .init(base: base.getAttributes())
        }
        
        var text: String? {
            try? base.text()
        }
        
        typealias Elements = LazyMapSequence<LazySequence<SwiftSoup.Elements>.Elements, Document.Element>
        
        var children: Elements {
            base.children().lazy.map(Element.init)
        }
        
        fileprivate init(_ element: SwiftSoup.Element) {
            base = element
        }
    }
    
    struct Attributes {
        fileprivate let base: SwiftSoup.Attributes?
        
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
        case openElement(Element)
        case closeElement(Element)
    }
    
    struct EventSequence: Sequence {
        let element: Element
        func makeIterator() -> EventIterator {
            EventIterator(element: element)
        }
    }
    
    final class EventIterator: IteratorProtocol {
        let element: Document.Element
        var iterator: Document.Element.Elements.Iterator? = nil
        var childIterator: EventIterator? = nil
        var elementIsClosed = false
        
        init(element: Document.Element) {
            self.element = element
        }
        
        func next() -> Event? {
            if elementIsClosed {
                return nil
            }
            
            else if iterator == nil {
                self.iterator = element.children.makeIterator()
                return .openElement(element)
            }
            
            while true {
                if let event = childIterator?.next() {
                    return event
                } else {
                    if let childIterator = iterator?.next().map(EventIterator.init(element:)) {
                        self.childIterator = childIterator
                    } else {
                        elementIsClosed = true
                        return .closeElement(element)
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

extension Document.Element {
    var events: Document.EventSequence {
        .init(element: self)
    }
}
