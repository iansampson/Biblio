//
//  CrossRef.swift
//  
//
//  Created by Ian Sampson on 2021-11-20.
//

import LibraryOfCongress
import CrossRef

extension Instance {
    init(_ work: CrossRef.Work) {
        // Do we know if it’s print or not?
        // No: CrossRef actually descibes a Work, not an Instance.
        // type = .instance
        if work.publishedPrint == nil {
            type = .electronic
        } else {
            type = .print
        }
        
        identifiers = [
            [Identifier(type: .doi, value: work.doi)],
            work.issn?.map { Identifier(type: .issn, value: $0) } ?? [],
            work.issnType?.map { Identifier(type: .issn, value: $0.value) } ?? []
        // TODO: Add URL to InstanceType and include work.url
        ]
            .lazy
            .flatMap { $0 }
        
        carrier = nil
        // TODO: Consider maping CrossRef.WorkType to Carrier
        
        issuance = .init(work.type)
        
        // let provisions
        
        title = work.title.first.map({
            Title(primaryTitle: $0,
                  subtitle: work.subtitle?.first,
                  abbreviatedTitle: nil)
        })
        
        self.work = .init(work)
        
        container = .init(work)
        
        images = []
        
        let publisher = work.publisher.map {
            Agent(type: .organization, identifiers: [], name: .init(components: [$0]))
        }
        
        let publication = Provision(type: .published,
                  agent: publisher,
                  place: work.publisherLocation, // TODO: Parse location
                  date: work.published.flatMap(Date.init))
        
        let created = Provision(type: .created, agent: nil, place: nil, date: .init(work.created))
        let issued = Provision(type: .issued, agent: nil, place: nil, date: .init(work.issued))
        let posted = work.posted.map { Provision(type: .posted, agent: nil, place: nil, date: .init($0)) }
        let deposited = Provision(type: .deposited, agent: nil, place: nil, date: .init(work.deposited))
        let indexed = Provision(type: .indexed, agent: nil, place: nil, date: .init(work.indexed))
        // TODO: Consider adding a property for published print (or printed)
        
        provisions = [publication, created, issued, posted, deposited, indexed].compactMap { $0 }
        
        // ISSN and ISBN *may* be container identifiers
    }
}

extension Date {
    init?(_ dateParts: DateParts) {
        var parts = dateParts.dateParts?.flatMap { $0.compactMap { $0} }[...] ?? []
        guard let year = parts.popFirst() else {
            return nil
        }
        let month = parts.popFirst()
        let day = parts.popFirst()
        self.init(day: day,
             month: month,
             season: nil,
             year: year)
    }
}

extension Container {
    init?(_ work: CrossRef.Work) {
        identifiers = work.issn?.compactMap { .init(type: .issn, value: $0) } ?? []
        
        title = work.containerTitle?.first.map({
            Title(primaryTitle: $0,
                  subtitle: nil,
                  abbreviatedTitle: work.shortContainerTitle?.first)})
        
        locators = [Locator(unit: .page, string: work.page),
                    Locator(unit: .issue, string: work.issue),
                    Locator(unit: .volume, string: work.volume)]
            .compactMap { $0 }
    }
}

extension Locator {
    init?(unit: Locator.Unit, string: String?) {
        guard let string = string,
              let range = Locator.Range(string)
        else {
            return nil
        }
        self = Locator(unit: unit, ranges: [range])
    }
}

// TODO: Handle multiple ranges, e.g. 45-7, 3-2, etc.
extension Locator.Range { // OpenRange
    init?(_ string: String) {
        var substrings = string.split(separator: "-")[...]
        guard let lowerBound = substrings.popFirst() else {
            return nil
        }
        self.lowerBound = String(lowerBound)
        upperBound = substrings.popFirst().map(String.init)
    }
}

extension Issuance {
    init?(_ workType: CrossRef.WorkType) {
        switch workType {
        case .bookSeries, .journal, .journalArticle, .journalIssue, .journalWork, .proceedingsSeries, .reportSeries, .standardSeries:
            // TODO: Are journal articles and issues serial works? Or just *part* of serial works?
            self = .serial
        case .book, .bookChapter, .bookPart, .bookSection, .dissertation, .editedBook, .monograph, .proceedings, .proceedingsArticle, .referenceBook, .referenceEntry, .peerReview, .report, .standard, .component, .dataset:
            self = .monograph
        case .postedContent: // Could also be serial
            self = .integrating
        case .bookSet:
            self = .multivolumeMonograph
        case .other, .bookTrack:
            return nil // Or make an .unknown type
            // Component: supplemental material (e.g. for a journal article)
            // https://www.crossref.org/documentation/content-registration/structural-metadata/components/
            // https://www.crossref.org/documentation/content-registration/structural-metadata/structures-books/
            // https://crossref.gitlab.io/knowledge_base/docs/topics/content-types/
            // Dataset could be a monograph, but it could also be regularly updated
            // What is a book track?
            // What is a component?
        }
    }
}

extension Work {
    init(_ work: CrossRef.Work) {
        type = .init(work.type)
        
        let contributors: [[Contributor]] = [
            .init(authors: work.author, role: .author),
            .init(authors: work.translator, role: .translator),
            .init(authors: work.editor, role: .editor)
        ]
        self.contributors = contributors.flatMap { $0 }
        
        // TODO: Convert type to genre forms
        genreForms = []
        
        languages = work.language.flatMap(Language.init(iso639_1:)).map { [$0] } ?? []
    }
}


extension LibraryOfCongress.WorkType {
    init(_ type: CrossRef.WorkType) {
        switch type {
        case .book, .bookChapter, .bookPart, .bookSection, .bookSeries, .bookSet, .bookTrack, .dissertation, .editedBook, .journal, .journalArticle, .journalIssue, .journalWork, .monograph, .peerReview, .proceedings, .proceedingsArticle, .proceedingsSeries, .referenceBook, .referenceEntry, .report, .reportSeries, .standard, .standardSeries:
            self = .text
        case .postedContent:
            // Could also be image, video, etc. (e.g. on YouTube or Instagram)
            self = .text
        case .dataset:
            self = .dataset
        case .other, .component:
            self = .work
        }
    }
}

extension Array where Element == Contributor {
    init(authors: [Author]?, role: Contributor.Role) {
        self = authors?.lazy
            .compactMap(Agent.init)
            .compactMap { Contributor(agent: $0, roles: [role]) } ?? []
    }
}

extension Agent {
    init?(_ author: CrossRef.Author) {
        type = .person
        identifiers = author.orcid.map { [Identifier(type: .orcid, value: $0)] } ?? []
        if let given = author.given,
           let family = author.family
        {
            name = .init(components: [given, family])
        } // else if let name = author.name {
            // TODO: Parse name
            // TODO: Handle prefix and suffix
            // TODO: Consider sequence
        // }
        else {
            return nil
        }
    }
}
