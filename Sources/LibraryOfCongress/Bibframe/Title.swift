//
//  Title.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

public struct Title {
    public let type: TitleType
    public let value: String
}

public enum TitleType: String {
    case regular = "http://id.loc.gov/ontologies/bibframe/Title"
    case variant = "http://id.loc.gov/ontologies/bibframe/VariantTitle"
    case parallel = "http://id.loc.gov/ontologies/bibframe/ParallelTitle"
    case abbreviated = "http://id.loc.gov/ontologies/bibframe/AbbreviatedTitle"
    case key = "http://id.loc.gov/ontologies/bibframe/KeyTitle"
    case collective = "http://id.loc.gov/ontologies/bibframe/CollectiveTitle"
}
