//
//  Crawler.swift
//  
//
//  Created by Ian Sampson on 2021-11-18.
//

import Foundation
import CrossRef

public final class MetadataCrawler {
    let urlSession: URLSession
    
    public init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    // TODO: When resolving a CoAccess reference
    // distinguish the primary result from relations with an enum property
    public func metadata(atURL url: URL) -> TaskStream<Metadata> {
        return TaskStream<Metadata> { [weak urlSession] taskGroup in
            guard let url = url.secure else {
                fatalError()
            }
                                          
            guard let urlSession = urlSession else {
                return
            }
            
            let (data, response) = try await urlSession.data(from: url)
            
            if let redirectedURL = response.url,
               let reference = CoAccess.Reference(htmlURL: redirectedURL)
            {
                let (data, _) = try await urlSession.data(from: reference.jsonUrl)
                let decoder = JSONDecoder()
                let deposit = try decoder.decode(CoAccess.Deposit.self, from: data)
                
                if let url = deposit.url {
                    taskGroup.addTask {
                        let (data, _) = try await urlSession.data(from: url)
                        return try MetadataParser().parse(data, from: url)
                    }
                }
                
                if let relations = deposit.relations {
                    for relation in relations {
                        taskGroup.addTask {
                            let url = relation.url
                            let (data, _) = try await urlSession.data(from: url)
                            return try MetadataParser().parse(data, from: url)
                        }
                    }
                }
            } else {
                guard let url = response.url?.secure else {
                    fatalError()
                }
                taskGroup.addTask {
                    try MetadataParser().parse(data, from: url)
                }
            }
        }
    }
}
