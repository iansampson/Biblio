//
//  Work.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import Foundation

public struct Work: Codable {
    public let title: [String]?
    public let subtitle: [String]?
    public let containerTitle: [String]?
    public let shortContainerTitle: [String]?
    
    public let author: [Author]?
    public let editor: [Author]?
    public let translator: [Author]?
    
    public let type: ItemType?
    public let doi: String?
    public let created: DateParts?
    public let issued: DateParts?
    public let published: DateParts?
    public let publishedPrint: DateParts?
    public let deposited: DateParts
    public let indexed: DateParts?
    public let subject: [String]?
    public let url: URL?
    public let issn: [String]? // or ISSN?
    public let issnType: [ISSNType]?
    public let alternativeId: [String]?
    public let journalIssue: JournalIssue?
    public let referencesCount: Int?
    public let score: Double? // ?
    public let link: [Link]? // TODO: Consider renaming to links (and adding a coding key)
    public let language: String?
    // TODO: Use an enum
    public let member: String?
    public let issue: String?
    public let volume: String?
    public let prefix: String?
    public let isReferencedByCount: Int?
    public let source: String?
    public let page: String? // TODO: Consider parsing
    // public let contentDomain: ContentDomain?
    public let publisher: String?   
}

// TODO: Consider name-spacing under Work
// (the docs have WorkISSNType)
public struct ISSNType: Codable {
    public let value: String
    public let type: String
    // TODO: Consider using an enum for type
    // if you can find a list of values
}

public struct JournalIssue: Codable {
    public let issue: String
    public let publishedPrint: DateParts
}
