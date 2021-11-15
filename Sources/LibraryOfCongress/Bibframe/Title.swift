//
//  Title.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

struct Title {
    let type: TitleType
    let value: String
}

enum TitleType: String {
    case regular = "http://id.loc.gov/ontologies/bibframe/Title"
    case variant = "http://id.loc.gov/ontologies/bibframe/VariantTitle"
    case parallel = "http://id.loc.gov/ontologies/bibframe/ParallelTitle"
    case abbreviated = "http://id.loc.gov/ontologies/bibframe/AbbreviatedTitle"
    case key = "http://id.loc.gov/ontologies/bibframe/KeyTitle"
    case collective = "http://id.loc.gov/ontologies/bibframe/CollectiveTitle"
}
