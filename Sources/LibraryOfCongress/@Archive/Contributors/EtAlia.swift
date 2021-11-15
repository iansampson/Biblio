//
//  EtAlia.swift
//  
//
//  Created by Ian Sampson on 2021-11-14.
//

struct EtAlia {
    static func parse(_ input: ArraySlice<Contributors.Token>) -> (ArraySlice<Contributors.Token>, ())? {
        var remainingInput = input
        guard let token = remainingInput.popFirst() else {
            return nil
        }
        
        switch token.substring {
        case "et", "&":
            guard let token = remainingInput.popFirst() else {
                return nil
            }
            switch token.substring {
            case "al", "al.", "alia", "ux":
                return (remainingInput, ())
            default:
                return nil
            }
        default:
            return nil
        }
    }
}

