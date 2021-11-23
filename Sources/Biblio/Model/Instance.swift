//
//  Instance.swift
//  
//
//  Created by Ian Sampson on 2021-11-19.
//

import LibraryOfCongress

struct Instance {
    var identifiers: [Identifier] // dictionary?
    let type: InstanceType
    let carrier: Carrier? // medium
    let issuance: Issuance?
    let provisions: [Provision] // provisionActivities?
    let title: Title?
    // TODO: Consider allowing multiple titles, as Bibframe does
    // (for variants, abbreviated titles, etc.)
    let work: Work?
    let container: Container?
    var images: [Image]
}

extension Instance {
    struct Identifier: Hashable {
        let type: IdentifierType
        let value: String
    }
}
