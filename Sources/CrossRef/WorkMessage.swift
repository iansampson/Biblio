//
//  WorkMessage.swift
//  
//
//  Created by Ian Sampson on 2021-11-19.
//

public struct WorksMessage: Codable {
    public let status: String
    public let messageType: String
    public let messageVersion: String
    public let message: Works
}
