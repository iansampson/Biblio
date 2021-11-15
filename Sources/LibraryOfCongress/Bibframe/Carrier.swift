//
//  Carrier.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

public enum Carrier: String {
    case apertureCard = "http://id.loc.gov/vocabulary/carriers/ha"
    case audioCartridge = "http://id.loc.gov/vocabulary/carriers/sg"
    case audioCylinder = "http://id.loc.gov/vocabulary/carriers/se"
    case audioDisc = "http://id.loc.gov/vocabulary/carriers/sd"
    case audioRoll = "http://id.loc.gov/vocabulary/carriers/sq"
    case audiocassette = "http://id.loc.gov/vocabulary/carriers/ss"
    case audiotapeReel = "http://id.loc.gov/vocabulary/carriers/st"
    case card = "http://id.loc.gov/vocabulary/carriers/no"
    case computerCard = "http://id.loc.gov/vocabulary/carriers/ck"
    case computerChipCartridge = "http://id.loc.gov/vocabulary/carriers/cb"
    case computerDisc = "http://id.loc.gov/vocabulary/carriers/cd"
    case computerDiscCartridge = "http://id.loc.gov/vocabulary/carriers/ce"
    case computerTapeCartridge = "http://id.loc.gov/vocabulary/carriers/ca"
    case computerTapeCassette = "http://id.loc.gov/vocabulary/carriers/cf"
    case computerTapeReel = "http://id.loc.gov/vocabulary/carriers/ch"
    case filmCartridge = "http://id.loc.gov/vocabulary/carriers/mc"
    case filmCassette = "http://id.loc.gov/vocabulary/carriers/mf"
    case filmReel = "http://id.loc.gov/vocabulary/carriers/mr"
    case filmRoll = "http://id.loc.gov/vocabulary/carriers/mo"
    case filmslip = "http://id.loc.gov/vocabulary/carriers/gd"
    case filmstrip = "http://id.loc.gov/vocabulary/carriers/gf"
    case filmstripCartridge = "http://id.loc.gov/vocabulary/carriers/gc"
    case flipchart = "http://id.loc.gov/vocabulary/carriers/nn"
    case microfiche = "http://id.loc.gov/vocabulary/carriers/he"
    case microficheCassette = "http://id.loc.gov/vocabulary/carriers/hf"
    case microfilmCartridge = "http://id.loc.gov/vocabulary/carriers/hb"
    case microfilmCassette = "http://id.loc.gov/vocabulary/carriers/hc"
    case microfilmReel = "http://id.loc.gov/vocabulary/carriers/hd"
    case microfilmRoll = "http://id.loc.gov/vocabulary/carriers/hj"
    case microfilmSlip = "http://id.loc.gov/vocabulary/carriers/hh"
    case microopaque = "http://id.loc.gov/vocabulary/carriers/hg"
    case microscopeSlide = "http://id.loc.gov/vocabulary/carriers/pp"
    case object = "http://id.loc.gov/vocabulary/carriers/nr"
    case onlineResource = "http://id.loc.gov/vocabulary/carriers/cr"
    case otherAudioCarrier = "http://id.loc.gov/vocabulary/carriers/sz"
    case otherComputerCarrier = "http://id.loc.gov/vocabulary/carriers/cz"
    case otherMicroformCarrier = "http://id.loc.gov/vocabulary/carriers/hz"
    case otherMicroscopicCarrier = "http://id.loc.gov/vocabulary/carriers/pz"
    case otherProjectedCarrier = "http://id.loc.gov/vocabulary/carriers/mz"
    case otherStereographicCarrier = "http://id.loc.gov/vocabulary/carriers/ez"
    case otherUnmediatedCarrier = "http://id.loc.gov/vocabulary/carriers/nz"
    case otherVideoCarrier = "http://id.loc.gov/vocabulary/carriers/vz"
    case overheadTransparency = "http://id.loc.gov/vocabulary/carriers/gt"
    case roll = "http://id.loc.gov/vocabulary/carriers/na"
    case sheet = "http://id.loc.gov/vocabulary/carriers/nb"
    case slide = "http://id.loc.gov/vocabulary/carriers/gs"
    case soundTrackReel = "http://id.loc.gov/vocabulary/carriers/si"
    case stereographCard = "http://id.loc.gov/vocabulary/carriers/eh"
    case stereographDisc = "http://id.loc.gov/vocabulary/carriers/es"
    case unspecified = "http://id.loc.gov/vocabulary/carriers/zu"
    case videoCartridge = "http://id.loc.gov/vocabulary/carriers/vc"
    case videocassette = "http://id.loc.gov/vocabulary/carriers/vf"
    case videodisc = "http://id.loc.gov/vocabulary/carriers/vd"
    case videotapeReel = "http://id.loc.gov/vocabulary/carriers/vr"
    case volume = "http://id.loc.gov/vocabulary/carriers/nc"
}

extension Carrier {
    init?(expanding links: [Link]?, in document: Document) throws {
        let carrier = links?
            .lazy
            .compactMap { $0.id }
            .compactMap(Self.init(rawValue:))
            .first
        
        if let carrier = carrier {
            self = carrier
        } else {
            return nil
        }
    }
}
