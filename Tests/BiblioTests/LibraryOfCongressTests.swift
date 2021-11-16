//
//  LibraryOfCongressTests.swift
//  
//
//  Created by Ian Sampson on 2021-11-13.
//

import XCTest
import LibraryOfCongress

final class LibraryOfCongressTests: XCTestCase {
    func testSearch() async throws {
        let results = try await LinkedDataService().search("Walter Benjamin")
        XCTAssert(!results.isEmpty)
    }
    
    func testRetrieveInstance() async throws {
        // Given
        let service = LinkedDataService()
        
        // When
        let instance = try await service.instance(withID: "20953723")
        
        // Then
        XCTAssertEqual(instance.title?.value, "Magyarázni")
    }
    
    func testRetrieveWorkWithID() async throws {
        // Given
        let service = LinkedDataService()
        
        // When
        let work = try await service.work(withID: "20953723")
        
        // Then
        XCTAssertEqual(work.contributions.first?.roles, [.author, .illustrator])
    }
    
    func testRetrieveWorkFromInstance() async throws {
        // Given
        let service = LinkedDataService()
        let instance = try await service.instance(withID: "20953723")
        
        // When
        // TODO: Consider renaming to from
        let work = try await service.work(for: instance)
        
        // Then
        XCTAssertEqual(work.contributions.first?.roles, [.author, .illustrator])
    }
    
    func testDecodeInstance() throws {
        // Given
        let data = try Data(name: "702963", extension: "json")
        
        // When
        let instance = try JSONDecoder().decode(Instance.self, from: data)
        
        // Then
        XCTAssertEqual(instance.type, .print)
        XCTAssertEqual(instance.identifiers.count, 3)
        XCTAssertNotNil(instance.work)
        XCTAssertEqual(instance.title?.value, "Dani Karavan")
        XCTAssertEqual(instance.variantTitle?.value, "Hommage an Walter Benjamin")
        XCTAssertEqual(instance.provisionActivity?.place, "Mainz")
        XCTAssertNotNil(instance.responsibilityStatement)
        XCTAssertEqual(instance.issuance, .monograph)
        XCTAssertEqual(instance.extent?.string, "181 p.")
        XCTAssertEqual(instance.carrier, .volume)
    }
    
    func testDecodeWork() throws {
        // Given
        let data = try Data(name: "20953723", extension: "json")
        
        // When
        let work = try JSONDecoder().decode(Work.self, from: data)
        
        // Then
        XCTAssertEqual(work.type, .text)
        XCTAssertEqual(work.contributions.count, 2)
        XCTAssertEqual(work.contributions.first?.roles, [.author, .illustrator])
        XCTAssertEqual(work.contributions.map { $0.agent.name.components }, [["Helen", "Hajnoczky"], ["Susan L.", "Holbrook"]])
        XCTAssertEqual(work.languages, [.english])
    }
}

enum TestError: Error {
    case missingTestData
}

extension Data {
    init(name: String, extension: String) throws {
        guard let url = Bundle.module.url(forResource: name, withExtension: "json") else {
            throw TestError.missingTestData
        }
        try self.init(contentsOf: url)
    }
}

// TODO: Throw error when trying to decode something that is *not* a Work
// TODO: Parse names
// TODO: Mark primary contributor(s)
// TODO: Add search again
// TODO: Fetch Work from Instance
