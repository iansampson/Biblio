//
//  LibraryOfCongressTests.swift
//  
//
//  Created by Ian Sampson on 2021-11-13.
//

import XCTest
@testable import LibraryOfCongress

final class LibraryOfCongressTests: XCTestCase {
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
    }
}
// TODO: Throw error when trying to decode something that is *not* a Work
// TODO: Parse names
// TODO: Mark primary contributor(s)
// TODO: Add search again
// TODO: Fetch Work from Instance

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
