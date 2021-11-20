//
//  Instance.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

// TODO: Consider renaming to Work
// (although this object is analagous to a Bibframe.Instance)

import Foundation
import GoogleBooks
import LibraryOfCongress

public struct Instance {
    let sources: Sources
    
    public var imageURL: URL? {
        sources.googleVolume?.volumeInfo.imageLinks?.uncurled.thumbnail
    }
    
    public var title: String? {
        sources.libraryOfCongress.instance?.title?.value
        ?? sources.googleVolume?.volumeInfo.title
    }
    
    public var subtitle: String? {
        sources.libraryOfCongress.instance?.variantTitle?.value
        ?? sources.googleVolume?.volumeInfo.subtitle
    }
    
    public var contributors: [LibraryOfCongress.Contribution] {
        sources.libraryOfCongress.work?.contributions ?? []
        // TODO: Consider using Google authors too
    }
}

// This info is for books.
// You can use a separate object for journal articles
// or just add CrossRef metadata to this one.
extension Instance {
    struct Sources {
        let googleVolume: GoogleVolume?
        let libraryOfCongress: BibframeObject
        
        struct BibframeObject {
            let instance: LibraryOfCongress.Instance?
            let work: LibraryOfCongress.Work?
        }
    }
}
