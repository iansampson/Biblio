//
//  Instance.swift
//  
//
//  Created by Ian Sampson on 2021-11-19.
//

import LibraryOfCongress

struct Instance {
    // work type
    // instance type
    // genre
    // carrier
    // issuance
    let identifiers: [Identifier]
    let contributors: [Contributor] // contributions?
    let provisions: [Provision] // provisionActivities?
    let title: Title?
    let languages: [Language] // Languages
    // TODO: Identify a primary language
    let container: Container? // isPartOf
    // let work (isInstanceOf)
}

extension Instance {
    typealias IdentifierType = LibraryOfCongress.IdentifierType
    // TODO: Consider namespacing IdentifierType under Bibframe
    
    typealias Language = LibraryOfCongress.Language
    
    struct Identifier {
        let type: IdentifierType
        let value: String
    }
}
