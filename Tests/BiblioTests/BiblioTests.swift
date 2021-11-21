//
//  BiblioTests.swift
//
//
//  Created by Ian Sampson on 2021-11-15.
//

import XCTest
@testable import Biblio
@testable import CrossRef
import LibraryOfCongress
import Metadata
import LetterCase

final class BiblioTests: XCTestCase {
    /*func testSearch() async throws {
        // Given
        let library = Library()
        
        // When
        let instances = try await library.search(for: "Helen Hajnoczky")
        
        // Then
        print(instances)
    }*/
    
    func testMetadataClient() async throws {
        // Given
        let crossRef = CrossRef.Service()
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
    
    func testConstructInstanceFromBibframe() throws {
        // Given
        let decoder = JSONDecoder()
        let workData = try Data(name: "16625871", extension: "json")
        let instanceData = try Data(name: "instances16625871", extension: "json")
        let bibframeWork = try decoder.decode(LibraryOfCongress.Work.self, from: workData)
        let bibframeInstance = try decoder.decode(LibraryOfCongress.Instance.self, from: instanceData)
        
        // When
        let instance = Biblio.Instance(instance: bibframeInstance, work: bibframeWork)
        
        // Then
        dump(instance)
        
        // TODO: Remove period when parsing name
    }
    
    func testConstructInstanceFromCrossRef() throws {
        // Given
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromKebabCase
        decoder.dateDecodingStrategy = .iso8601
        let crossRefData = try Data(name: "0008-6215(90)84065-3", extension: "json")
        let crossRefWork = try decoder.decode(CrossRef.Work.self, from: crossRefData)
        
        // When
        let instance = Biblio.Instance(crossRefWork)
        
        // Then
        dump(instance)
    }
    
    func testRetrieveInstanceWithISBN() async throws {
        // Given
        let service = Biblio.Service(urlSession: .shared)
        
        // When
        let instance = try await service.instance(withISBN: "9781552453278")
        
        // Then
        dump(instance)
    }
}
