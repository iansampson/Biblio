//
//  XMLDocument.swift
//  
//
//  Created by Ian Sampson on 2021-11-18.
//

import Foundation

struct XMLDocument {
    private let data: Data
    typealias HandleEvent = ((Event) -> ())
    
    init(_ data: Data) {
        self.data = data
    }
    
    func events(_ handleEvent: @escaping HandleEvent) {
        Parser().parse(data, handleEvent)
    }
    
    struct Element {
        let name: String
        let namespaceURI: String?
        let qualifiedName: String?
        let attributes: [String: String]
    }
    
    enum Event {
        case openDocument
        case closeDocument
        case openElement(Element)
        case closeElement(Element)
        case text(String)
        case error(Error)
    }
}

extension XMLDocument {
    fileprivate final class Parser {
        private var base: XMLParser?
        private var coordinator: Coordinator?
        
        // TODO: Consider returning a Publisher where Combine is available
        func parse(_ data: Data, _ handleEvent: @escaping HandleEvent) {
            let parser = XMLParser(data: data)
            let coordinator = Coordinator(handleEvent: handleEvent)
            parser.delegate = coordinator
            self.coordinator = coordinator
            base = parser
            parser.parse()
        }
    }
}

extension XMLDocument.Parser {
    final class Coordinator: NSObject, XMLParserDelegate {
        typealias Element = XMLDocument.Element
        typealias Event = XMLDocument.Event
        typealias HandleEvent = XMLDocument.HandleEvent
        
        let handleEvent: HandleEvent
        
        init(handleEvent: @escaping HandleEvent) {
            self.handleEvent = handleEvent
        }
        
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            let element = Element(name: elementName,
                                  namespaceURI: namespaceURI,
                                  qualifiedName: qName,
                                  attributes: attributeDict)
            let event = Event.openElement(element)
            handleEvent(event)
        }
        
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            let event = Event.text(string)
            handleEvent(event)
        }
        
        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            let element = Element(name: elementName,
                                  namespaceURI: namespaceURI,
                                  qualifiedName: qName,
                                  attributes: [:])
            let event = Event.closeElement(element)
            handleEvent(event)
        }
        
        func parserDidStartDocument(_ parser: XMLParser) {
            handleEvent(.openDocument)
        }
        
        func parserDidEndDocument(_ parser: XMLParser) {
            handleEvent(.closeDocument)
        }
        
        func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
            handleEvent(.error(parseError))
            
        }
    }
}
