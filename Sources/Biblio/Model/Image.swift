//
//  Image.swift
//  
//
//  Created by Ian Sampson on 2021-11-20.
//

import Foundation

struct Image {
    let subject: Subject
    let url: URL
}

extension Image {
    enum Subject {
        case cover
    }
}
