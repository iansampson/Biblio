//
//  Item.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import Foundation

public struct Item: Codable {
    public let title: [String]?
    public let subtitle: [String]?
    public let containerTitle: [String]?
    public let shortContainerTitle: [String]?
    public let author: [Person]?
    public let type: ItemType?
    public let doi: String?
    public let created: Date?
    public let issued: Date?
    public let published: Date?
    public let publishedPrint: Date?
    public let deposited: Date
    public let indexed: Date?
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

public struct ISSNType: Codable {
    public let value: String
    public let type: String
    // TODO: Consider using an enum for type
    // if you can find a list of values
}

public struct JournalIssue: Codable {
    public let issue: String
    public let publishedPrint: Date
}
