//
//  ItemType.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

public enum ItemType: String, Codable {
    case book
    case bookChapter = "book-chapter"
    case bookPart = "book-part"
    case bookSection = "book-section"
    case bookSeries = "book-series"
    case bookSet = "book-set"
    case bookTrack = "book-track"
    case component
    case dataset
    case dissertation
    case editedBook = "edited-book"
    case journal
    case journalArticle = "journal-article"
    case journalIssue = "journal-issue"
    case journalWork = "journal-volume"
    case monograph
    case other
    case peerReview = "peer-review"
    case postedContent = "posted-content"
    case proceedings
    case proceedingsArticle = "proceedings-article"
    case proceedingsSeries = "proceedings-series"
    case referenceBook = "reference-book"
    case referenceEntry = "reference-entry"
    case report
    case reportSeries = "report-series"
    case standard
    case standardSeries = "standard-series"
}

// TODO: Consider using convertFromKebabCase settings on the JSONDecoder instead
// (which we already do, so these raw types may not be necessary.)
