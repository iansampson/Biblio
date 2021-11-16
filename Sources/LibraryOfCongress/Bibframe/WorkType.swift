//
//  WorkType.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

public enum WorkType: String {
    case hub = "http://id.loc.gov/ontologies/bibframe/Hub"
    case text = "http://id.loc.gov/ontologies/bibframe/Text"
    case cartography = "http://id.loc.gov/ontologies/bibframe/Cartography"
    case audio = "http://id.loc.gov/ontologies/bibframe/Audio"
    case notatedMusic = "http://id.loc.gov/ontologies/bibframe/NotatedMusic"
    case notatedMovement = "http://id.loc.gov/ontologies/bibframe/NotatedMovement"
    case dataset = "http://id.loc.gov/ontologies/bibframe/Dataset"
    case stillImage = "http://id.loc.gov/ontologies/bibframe/StillImage"
    case movingImage = "http://id.loc.gov/ontologies/bibframe/MovingImage"
    case object = "http://id.loc.gov/ontologies/bibframe/Object"
    case multimedia = "http://id.loc.gov/ontologies/bibframe/Multimedia"
    case mixedMaterial = "http://id.loc.gov/ontologies/bibframe/MixedMaterial"
    case arrangement = "http://id.loc.gov/ontologies/bibframe/Arrangement"
    case work = "http://id.loc.gov/ontologies/bibframe/Work"
}
