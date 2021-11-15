//
//  File.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import Foundation

// TODO: Consider nesting under LinkedData
// or renaming to something simple like Library
public final class LinkedDataService {
    let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}

extension LinkedDataService {
    public enum Error: Swift.Error {
        case invalidURL(URL)
        case expectedWorkPropertyOnInstance(Instance)
    }
    
    public func instance(atURL url: URL) async throws -> Instance {
        guard url.deletingLastPathComponent().lastPathComponent == "instances",
              url.pathExtension == "json"
        else {
            throw Error.invalidURL(url)
        }
        let (data, _) = try await urlSession.data(from: url)
        return try JSONDecoder().decode(Instance.self, from: data)
    }
    
    public func work(atURL url: URL) async throws -> Work {
        guard url.deletingLastPathComponent().lastPathComponent == "works",
              url.pathExtension == "json"
        else {
            throw Error.invalidURL(url)
        }
        let (data, _) = try await urlSession.data(from: url)
        return try JSONDecoder().decode(Work.self, from: data)
    }
    
    public func instance(withID id: String) async throws -> Instance {
        guard let url = URL(string: "https://id.loc.gov/resources/instances")?
                .appendingPathComponent(id)
                .appendingPathExtension("json")
        else {
            fatalError()
        }
        return try await instance(atURL: url)
    }
    
    public func work(withID id: String) async throws -> Work {
        guard let url = URL(string: "https://id.loc.gov/resources/works")?
                .appendingPathComponent(id)
                .appendingPathExtension("json")
        else {
            fatalError()
        }
        return try await work(atURL: url)
    }
    
    public func work(for instance: Instance) async throws -> Work {
        guard let url = instance.work else {
            throw Error.expectedWorkPropertyOnInstance(instance)
        }
        let (data, _) = try await urlSession.data(from: url)
        return try JSONDecoder().decode(Work.self, from: data)
    }
}

// Consider making a more generic function such as:
// func object<T>(_ T.self, at url: URL) async throws
// and make T conform to some Bibframe-specific protocol
