//
//  ContributorRole.swift
//  
//
//  Created by Ian Sampson on 2021-11-14.
//

extension Contributor {
    public enum Role: Equatable {
        case author
        case introductionAuthor
        case translator
        case annotator
        case editor
        case seriesEditor
        case illustrator
    }
}

extension Contributor.Role {
    init?(word: Substring) {
        switch word.trimmingCharacters(in: .punctuationCharacters) {
        case "introduction":
            self = .introductionAuthor
        case "translator", "translated", "trans", "translation":
            self = .translator
        case "annotator", "annotated", "annot":
            self = .annotator
        case "editor", "edited", "ed", "eds", "edition":
            self = .editor
        case "series":
            self = .seriesEditor
        case "illustrator", "illustrated", "il", "ill", "illus", "illust":
            self = .illustrator
        default:
            return nil
        }
    }
}
