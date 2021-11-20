//
//  Container.swift
//  
//
//  Created by Ian Sampson on 2021-11-19.
//

struct Container {
    let identifiers: [Instance.Identifier]
    let title: Title?
    let locators: [Locator]
}

struct Locator {
    let unit: Unit
    let ranges: [Range]
}

extension Locator {
    enum Unit {
        case page
        // case paragraph
        // case section
        // case folio
        case issue
        case volume
    }
    
    struct Range {
        let lowerBound: String
        let upperBound: String
    }
}
