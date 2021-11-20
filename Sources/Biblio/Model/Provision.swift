//
//  Provision.swift
//  
//
//  Created by Ian Sampson on 2021-11-19.
//

struct Provision {
    let type: ProvisionType
    let agent: Agent?
    let place: String? // Place? // TODO: Strongly type Place
    let date: Date?
}

enum ProvisionType {
    case created
    case issued
    case published
    case posted
    case deposited
    case indexed
    case distributed
    case manufactured
    case produced
}

struct Date {
    let day: Int?
    let month: Int?
    let season: Season?
    let year: Int
}
// Could be a range, or a series of ranges

enum Season {
    case winter
    case spring
    case summer
    case fall
}

// TODO: Model place more precisely
struct Place {
    let city: Name
    let region: Name
    // let country: Name
}

// A place may have several names, e.g. city, state
