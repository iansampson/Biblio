//
//  Work.swift
//  
//
//  Created by Ian Sampson on 2021-11-20.
//

import LibraryOfCongress

struct Work {
    // public let identifiers
    public let type: WorkType
    public let contributors: [Contributor]
    public let languages: [Language]
    public let genreForms: [GenreForm]
    // TODO: Identify a primary language
}
