//
//  Image.swift
//  
//
//  Created by Ian Sampson on 2021-11-19.
//

import Foundation

extension HTMLMetadata {
    struct Image {
        let tag: String
        let url: URL
        
        private init?(attributeKey key: String, element: HTMLDocument.Element, context: Context) {
            guard element.name == "img" else {
                return nil
            }
            
            func matches(_ string: String) -> Bool {
                let string = string.lowercased()
                guard string.contains("book")
                        || string.contains("issue")
                        || string.contains("cover")
                        || string.contains("product"),
                      !string.contains("logo"),
                      !string.contains("icon"),
                      !string.contains("fallback")
                        // TODO: Consider splitting words into a set
                        // so you don’t have to search the whole string every time,
                        // or even using an NLP lemmatizer
                else {
                    return false
                }
                return true
            }
            
            var url: URL? {
                guard let destination = element.attributes["src"],
                      let url = URL(string: destination, relativeTo: context.url)
                else {
                    return nil
                }
                
                return url
            }
            
            for id in context.ids.reversed().prefix(2) {
                if matches(id) {
                    guard let url = url else {
                        return nil
                    }
                    self.tag = id
                    self.url = url
                    return
                }
            }
            
            for className in context.classes.reversed().prefix(2) {
                if matches(className) {
                    guard let url = url else {
                        return nil
                    }
                    self.tag = className
                    self.url = url
                    return
                }
            }
            
            guard let url = url else {
                return nil
            }
            
            if url.path.contains("cover") {
                self.tag = url.path
                self.url = url
                return
            }
            
            guard let tag = element.attributes[key]?.lowercased(),
                  matches(tag)
            else {
                return nil
            }
            self.tag = tag
            self.url = url
        }
        
        init(tag: String, url: URL) {
            self.tag = tag
            self.url = url
        }
        
        init?(_ element: HTMLDocument.Element, context: Context) {
            if let image = Self.init(attributeKey: "id", element: element, context: context)
                ?? Self.init(attributeKey: "class", element: element, context: context) {
                self = image
            } else {
                return nil
            }
        }
    }
}
