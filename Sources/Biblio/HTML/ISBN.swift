//
//  ISBN.swift
//  
//
//  Created by Ian Sampson on 2021-11-19.
//

extension HTMLMetadata {
    struct ISBN {
        // let type
        // TODO: Add source (e.g. metadata, body tag, label)
        // TODO: Add type (print, electronic, etc. where available)
        let value: String
        
        init(_ value: String) {
            self.value = value
        }
        
        init?(_ element: HTMLDocument.Element) {
            var isLabeledISBN: Bool {
                if let id = element.attributes["id"] {
                    if id.lowercased().contains("isbn") { return true }
                }
                
                if let className = element.attributes["class"] {
                    if className.lowercased().contains("isbn") { return true }
                }
                
                return false
            }
            
            guard element.name == "div" || element.name == "span",
                  isLabeledISBN
            else {
                return nil
            }
            
            let value = element.text?.components(separatedBy: .whitespacesAndNewlines)
                .filter {
                    for character in $0 {
                        if character.isNumber || character.lowercased() == "x" || character == "-" {
                            return true
                        } else {
                            return false
                        }
                    }
                    return true
                }
                .first

            if let value = value {
                self.value = value
            } else {
                return nil
            }
        }
    }
}
