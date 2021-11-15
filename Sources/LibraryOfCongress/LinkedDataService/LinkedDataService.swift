//
//  File.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import Foundation

public final class LinkedDataService {
    let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}

extension LinkedDataService {
    public func instance(at url: URL) async throws -> Instance {
        let (data, _) = try await urlSession.data(from: url)
        return try JSONDecoder().decode(Instance.self, from: data)
    }
    
    public func work(at url: URL) async throws -> Work {
        let (data, _) = try await urlSession.data(from: url)
        return try JSONDecoder().decode(Work.self, from: data)
    }
    
    public func work(for instance: Instance) async throws -> Work? {
        guard let url = instance.work else {
            return nil
            // TODO: Consider throwing an error or making `work`
            // a non-optional property on `Instance`
        }
        let (data, _) = try await urlSession.data(from: url)
        return try JSONDecoder().decode(Work.self, from: data)
    }
}
