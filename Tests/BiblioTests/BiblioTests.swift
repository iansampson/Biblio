//
//  BiblioTests.swift
//
//
//  Created by Ian Sampson on 2021-11-15.
//

import XCTest
@testable import Biblio
@testable import CrossRef

final class BiblioTests: XCTestCase {
    func testSearch() async throws {
        // Given
        let library = Library()
        
        // When
        let instances = try await library.search(for: "Helen Hajnoczky")
        
        // Then
        print(instances)
        /*guard let firstInstance = instances.first else {
            XCTFail()
            return
        }*/
        /*print(firstInstance.title)
        print(firstInstance.subtitle)
        print(firstInstance.contributors)
        print(firstInstance.imageURL)*/
    }
    
    /*func testParseHTML() async throws {
        // Given
        let data = try Data(name: "10.5250%2Fquiparle.19.2.0003", extension: "html")
        guard let string = String(bytes: data, encoding: .utf8) else {
            XCTFail()
            return
        }
        
        // When
        let result = try HTML.parse(string)
    }
    
    func testParseHTML2() async throws {
        // Given
        let data = try Data(name: "10.4324%2F9781315540559-13", extension: "html")
        guard let string = String(bytes: data, encoding: .utf8) else {
            XCTFail()
            return
        }
        
        // When
        let result = try HTML.parse(string, from: URL(string: ))
        dump(result)
    }*/
    
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
    
    func testMetadataClient() async throws {
        // Given
        let crossRef = CrossRef()
        let response = try await crossRef.search("Marjorie Perloff", type: .journalArticle)
        let urls = response.message.items?.map { $0.url } ?? []
        let metadataClient = MetadataClient(urlSession: .shared)
        
        // When
        /*let stream = TaskStream(urls) { url -> [HTMLMetadata.Parse] in
            var results: [HTMLMetadata.Parse] = []
            for try await result in metadataClient.metadata(atURL: url) {
                results.append(result)
            }
            return results
        }*/
        
        // TODO: Handle errors
        let stream = TaskStream(urls) { url in
            metadataClient.metadata(atURL: url)
        }
        
        /*let stream = AsyncThrowingStream<HTMLMetadata.Parse, Error> { continuation in
            Task {
                await withThrowingTaskGroup(of: TaskStream<HTMLMetadata.Parse>.self) { taskGroup in
                    for url in urls {
                        taskGroup.addTask {
                            let stream = metadataClient.metadata(atURL: url)
                            for try await result in stream {
                                continuation.yield(result)
                            }
                            return stream
                        }
                    }
                }
                continuation.finish(throwing: nil)
            }
        }*/
        
        // one continuation and several sequences
        
        // flatMap
        
        // TaskStream
        
        // () -> (TaskStream)
        
        // [URL] -> [[TaskStream]] -> TaskStream
        
        // You want to publish values *as they come in*
        // from any of the streams
        
        // for try await
        // 
        
        /*let stream = AsyncThrowingStream { () -> HTMLMetadata.Parse? in
            guard index < urls.count else {
                return nil
            }
            let url = urls[index]
            for try await result in metadataClient.metadata(atURL: url) {
                index += 1
                return result
            }
            fatalError()
            // return results
        }*/
        
        for try await result in stream {
            print(result)
        }
        
        /*let stream = AsyncThrowingStream<HTMLMetadata.Parse, Error> { continuation in
            withTaskGroup(of: HTMLMetadata.Parse.self) { taskGroup in
                
            }
            
            
            for url in urls {
                Task {
                    do {
                        for try await result in metadataClient.metadata(atURL: url) {
                            continuation.yield(result)
                        }
                        index += 1
                    } catch {
                        index += 1
                        continuation.finish(throwing: error)
                    }
                }
            }
        }
        
        for try await result in stream {
            print(result)
        }*/
        
        // for url in urls.prefix(3) {
        
        // }

        // TODO: Aggregate results into one result
        
        // Then
    }
    
    // See a list of class or ID names
    // and maybe some URLs too and just say, it is an image or no?
    // Probabilistic matching or whatever
    // Some kind of NLP
    
    
    /*func testMetadataParser() throws {
        // Given
        let data = try Data(name: "10.4324%2F9781315540559-13", extension: "html")
        
        // When
        let result = try HTMLMetadata().parse(data)
        print(result)
    }*/
}
// ISBN and other identifiers
// cover image

// TODO: Move to Biblio
struct SearchResult {
    var url: URL
    var isbn: String?
    var coverImageURL: URL?
    
    init(url: URL, result: HTML.Metadata.Result) {
        self.url = url
        isbn = result.isbn
        ?? result.openGraph.book[.isbn].first
        ?? result.openGraph.books[.isbn].first
        ?? result.citation[.isbn]?.first
        // TODO: Compare variant ISBNs and choose the most fitting one
        
        if let url = result.coverImageURL {
            coverImageURL = url
        }
        
        else if let string = result.openGraph[.image].first
            ?? result.openGraph.image[.url].first
            ?? result.openGraph.image[.secureUrl].first,
           let url = URL(string: string)
        {
            coverImageURL = url
        }
        
        else {
            coverImageURL = nil
        }
    }
}
