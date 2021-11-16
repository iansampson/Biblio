//
//  License.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import Foundation

public struct License: Codable {
    public let start: DateParts?
    public let contentVersion: String?
    public let delayInDays: Int?
    public let url: URL?
}
