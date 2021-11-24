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
import DOI
import ISBN

final class BiblioTests: XCTestCase {
    // TODO: Uncomment when you disambiguate TaskStream initializers
    /*func testMetadataClient() async throws {
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
    }*/
    
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
        let isbn = try ISBN("9781552453278")
        let instance = try await service.instance(withISBN: isbn)
        
        // Then
        guard let instance = instance else {
            XCTFail()
            return
        }
        XCTAssertFalse(instance.images.isEmpty)
    }
    
    func testRetrieveInstanceWithDOI() async throws {
        // Given
        let service = Biblio.Service(urlSession: .shared)
        let doi = try DOI("10.1086/715986")
        
        // When
        let instance = try await service.instance(withDOI: doi)
        
        // Then
        guard let instance = instance else {
            XCTFail()
            return
        }
        XCTAssertFalse(instance.images.isEmpty)
    }
    
    func testRetrieveInstanceFromWebpage() async throws {
        // Given
        let service = Biblio.Service(urlSession: .shared)
        let url = URL(string: "https://www.degruyter.com/document/doi/10.7312/hunt20122/html")!
        
        // When
        let instances = try await service.instancesFromHTML(atURL: url)
        
        // Then
        // TODO: Assert things
        for try await instance in instances {
            dump(instance)
        }
    }
}
