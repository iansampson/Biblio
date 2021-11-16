//
//  ItemType.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import LetterCase

public enum ItemType: String {
    case book
    case bookChapter
    case bookPart
    case bookSection
    case bookSeries
    case bookSet
    case bookTrack
    case component
    case dataset
    case dissertation
    case editedBook
    case journal
    case journalArticle
    case journalIssue
    case journalWork
    case monograph
    case other
    case peerReview
    case postedContent
    case proceedings
    case proceedingsArticle
    case proceedingsSeries
    case referenceBook
    case referenceEntry
    case report
    case reportSeries
    case standard
    case standardSeries
}

extension ItemType: Codable {
    public init(from decoder: Decoder) throws {
        let string = try String(from: decoder)
        guard let type = Self.init(rawValue: string.convert(from: .kebab, to: .lowerCamel)) else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                                                    debugDescription: "Failed to initialize ItemType enum from raw value: \(string)",
                                                    underlyingError: nil))
        }
        self = type
    }
    
    public func encode(to encoder: Encoder) throws {
        try rawValue.convert(from: .lowerCamel, to: .kebab)
            .encode(to: encoder)
    }
}
