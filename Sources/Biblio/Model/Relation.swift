//
//  Relation.swift
//  
//
//  Created by Ian Sampson on 2021-11-20.
//

struct Relation {
    let type: RelationType
    let objects: [Work] // Work or Instance // or just identifiers
    let direction: Direction
    
    enum Direction {
        case hasObject
        case isObjectOf
    }
}

enum RelationType {
    case relation
    case instance
    case expression
    case part
        case series
        case subseries
    case item
    case eventContent
    case equivalent
        case otherPhysicalFormat
        case reproduction
    case accompaniment
        case supplement
        case index
        case findingAid
        // case issued with
    case derivative
        case translation
        case original
    case precedent // prceded or succeeded by
        case separation // separatedFrom / splitInto
        case replacement
        case merger
        case continuation
        case continuationInPart
        case absorption
    case reference // referent
    case dataSource
    case arrangement
    case otherEdition
}
