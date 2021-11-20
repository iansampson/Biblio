//
//  Instance.swift
//  
//
//  Created by Ian Sampson on 2021-11-19.
//

import LibraryOfCongress

struct Instance {
    let identifiers: [Identifier] // dictionary?
    let type: InstanceType
    let carrier: Carrier? // medium
    let issuance: Issuance?
    let provisions: [Provision] // provisionActivities?
    let title: Title?
    let work: Work?
    let container: Container?
    let images: [Image]
}

extension Instance {
    struct Identifier {
        let type: IdentifierType
        let value: String
    }
}
