//
//  BiblioTests.swift
//
//
//  Created by Ian Sampson on 2021-11-15.
//

import XCTest
@testable import Biblio
@testable import CrossRef
import Metadata

final class BiblioTests: XCTestCase {
    func testSearch() async throws {
        // Given
        let library = Library()
        
        // When
        let instances = try await library.search(for: "Helen Hajnoczky")
        
        // Then
        print(instances)
    }
    
    func testMetadataClient() async throws {
        // Given
        let crossRef = CrossRef()
        let response = try await crossRef.search("Marjorie Perloff", type: .journalArticle)
        let urls = response.message.items?.map { $0.url } ?? []
        let metadataCrawler = MetadataCrawler(urlSession: .shared)

        // TODO: Handle errors
        let stream = TaskStream(urls) { url in
            metadataCrawler.metadata(atURL: url)
        }
        
        for try await result in stream {
            print(result)
        }
    }
}
