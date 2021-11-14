//
//  LibraryOfCongressTests.swift
//  
//
//  Created by Ian Sampson on 2021-11-13.
//

import XCTest
import LibraryOfCongress

final class LibraryOfCongressTests: XCTestCase {
    /*func testSearch() async throws {
        let results = try await LinkedDataService.search("Walter Benjamin")
    }*/
    
    func testDecodeIdentifierType() throws {
        // Given
        let string = "http://id.loc.gov/ontologies/bibframe/Lccn"
        let data = try JSONEncoder().encode(string)
        
        // When
        let decodedType = try JSONDecoder().decode(Bibframe.IdentifierType.self, from: data)
        
        // Then
        XCTAssertEqual(decodedType, .lccn)
    }
    
    func testDecodeInstance() throws {
        // Given
        guard let url = Bundle.module.url(forResource: "702963", withExtension: "json") else {
            XCTFail()
            return
        }
        let data = try Data(contentsOf: url)
        
        // When
        let instance = try JSONDecoder().decode(Instance.self, from: data)

        // Then
        XCTAssertEqual(Set(instance.identifiers.keys),
                       Set([.isbn, .local, .shelfMarkLcc, .lccn]))
        
        dump(instance.identifiers)
    }
}
