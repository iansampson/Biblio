//
//  MetadataClient.swift
//  
//
//  Created by Ian Sampson on 2021-11-18.
//

import Foundation
import CrossRef

// TODO: Rename
final class MetadataClient {
    let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    // TODO: When resolving a CoAccess reference
    // distinguish the primary result from relations with an enum property
    func metadata(atURL url: URL) -> TaskStream<HTMLMetadata.Parse> {
        return TaskStream<HTMLMetadata.Parse> { [weak urlSession] taskGroup in
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
                        return try HTMLMetadata().parse(data, from: url)
                    }
                }
                
                if let relations = deposit.relations {
                    for relation in relations {
                        taskGroup.addTask {
                            let url = relation.url
                            let (data, _) = try await urlSession.data(from: url)
                            return try HTMLMetadata().parse(data, from: url)
                        }
                    }
                }
            } else {
                guard let url = response.url?.secure else {
                    fatalError()
                }
                taskGroup.addTask {
                    try HTMLMetadata().parse(data, from: url)
                }
            }
        }
        
        /*AsyncThrowingStream { continuation in
            guard let url = url.secure else {
                fatalError()
            }
            
            Task {
                do {
                    let (data, response) = try await urlSession.data(from: url)
                    
                    if let redirectedURL = response.url,
                       let reference = CoAccess.Reference(htmlURL: redirectedURL)
                    {
                        let (data, _) = try await urlSession.data(from: reference.jsonUrl)
                        let decoder = JSONDecoder()
                        let deposit = try decoder.decode(CoAccess.Deposit.self, from: data)
                        
                        if let url = deposit.url {
                            let (data, _) = try await urlSession.data(from: url)
                            let result = try HTMLMetadata().parse(data, from: url)
                            continuation.yield(result)
                        }
                        
                        if let relations = deposit.relations {
                            for relation in relations {
                                let url = relation.url
                                let (data, _) = try await urlSession.data(from: url)
                                let result = try HTMLMetadata().parse(data, from: url)
                                continuation.yield(result)
                            }
                        }
                        
                        continuation.finish(throwing: nil)
                    } else {
                        guard let url = response.url?.secure else {
                            fatalError()
                        }
                        
                        let result = try HTMLMetadata().parse(data, from: url)
                        continuation.yield(result)
                        continuation.finish(throwing: nil)
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }*/
    }
}



// TODO: Extract CoAccess logic into CrossRef module
// var isFirstIteration = true
// var index = 0



/*var url: URL? {
    if isFirstIteration {
        isFirstIteration = false
        return deposit.url
    } else {
        guard let relations = deposit.relations,
              index < relations.count
        else {
            return nil
        }
        index += 1
        return relations[index].url
    }
}

    
    
    
    guard let url = url else {
        return nil
    }
    
    let (data, _) = try await urlSession.data(from: url)
    let result = try HTMLMetadata().parse(data, from: url)
    return result
}*/


/*
 func testParseRemoteHTML() async throws {
     // Given
     let crossRef = CrossRef()
     let response = try await crossRef.search("marjorie perloff", type: .bookChapter)
     
     let urls = response.message.items?.map { $0.url } ?? []
     var aggregateResults: [[(URL, HTML.Metadata.Result)]] = []
     
     // TODO: Secure URL
     for url in urls.prefix(10) {
         var results: [(URL, HTML.Metadata.Result)] = []
         
         guard let url = url.secure else {
             return
         }
         let (data, response) = try await URLSession.shared.data(from: url)
         if let url = response.url, let reference = CoAccess.Reference(htmlURL: url) {
             let (data, _) = try await URLSession.shared.data(from: reference.jsonUrl)
             let decoder = JSONDecoder()
             decoder.keyDecodingStrategy = .convertFromKebabCase
             let deposit = try decoder.decode(CoAccess.Deposit.self, from: data)
             
             if let url = deposit.url {
                 // print(url)
                 let (data, _) = try await URLSession.shared.data(from: url)
                 let result = try HTML.parse(data, from: url)
                 results.append((url, result))
             }
             
             for relation in deposit.relations ?? [] {
                 // print(relation.url)
                 let (data, _) = try await URLSession.shared.data(from: relation.url)
                 let result = try HTML.parse(data, from: url)
                 results.append((url, result))
             }
         } else {
             guard let url = response.url else {
                 fatalError()
             }
             let result = try HTML.parse(data, from: url)
             results.append((url, result))
         }
         
         aggregateResults.append(results)
     }
     
     var compositeResults: [SearchResult] = []
     for work in aggregateResults {
         var compositeResult: SearchResult?
         for result in work {
             let structuredResult = SearchResult(url: result.0, result: result.1)
             if compositeResult == nil {
                 compositeResult = structuredResult
             } else {
                 if compositeResult?.isbn == nil {
                     compositeResult?.isbn = structuredResult.isbn
                 }
                 
                 if compositeResult?.coverImageURL == nil {
                     compositeResult?.coverImageURL = structuredResult.coverImageURL
                 }
             }
             
             if compositeResult?.isbn == nil,
                let link = result.1.containerLink
             {
                 let (data, response) = try await URLSession.shared.data(from: link)
                 let result = try HTML.parse(data, from: response.url!)
                 let structuredResult = SearchResult(url: response.url!, result: result)
                 compositeResult?.isbn = structuredResult.isbn
             }
         }
         
         if let compositeResult = compositeResult {
             compositeResults.append(compositeResult)
         }
     }
     
     dump(compositeResults)
     // let isbns = results.map { $0.citation[.isbn]?.first ?? $0.openGraph.book[.isbn].first }
 }
 */
