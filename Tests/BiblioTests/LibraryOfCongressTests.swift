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
        XCTAssertNotNil(instance.responsibilityStatement)
        XCTAssertEqual(instance.identifiers.count, 3)
        XCTAssertNotNil(instance.work)
        print(instance)
    }
}

enum TestError: Error {
    case missingTestData
}

extension Data {
    init(name: String, extension: String) throws {
        guard let url = Bundle.module.url(forResource: "702963", withExtension: "json") else {
            throw TestError.missingTestData
        }
        try self.init(contentsOf: url)
    }
}

/*final class LibraryOfCongressTests: XCTestCase {
    func testSearch() async throws {
        let results = try await LinkedDataService.search("Derrida ear of the other")
        dump(results)
    }
    
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
        // TODO: Check contributor list
    }
    
    func testParseContributors() throws {
        // Given
        let responsibilityStatement = "translated by Esther Leslie; edited by Ursula Marx, Gudrun Schwarz, Michael Schwarz, Erdmut Wizisla"
        
        // When
        let contributors = Contributors(responsibilityStatement: responsibilityStatement)
        
        // Then
        // let editors = contributors.filter(byRole: .editor)
        print(contributors)
    }
    
    func testDecodeContributors() throws {
        // Given
        guard let url = Bundle.module.url(forResource: "4259802", withExtension: "json") else {
            XCTFail()
            return
        }
        let data = try Data(contentsOf: url)
        
        // When
        let instance = try JSONDecoder().decode(Instance.self, from: data)
        
        // Then
    }
    
    func testDecodeWork() throws {
        // Given
        guard let url = Bundle.module.url(forResource: "16625871", withExtension: "json") else {
            XCTFail()
            return
        }
        let data = try Data(contentsOf: url)
        
        // When
        let work = try JSONDecoder().decode(Bibframe.Work.self, from: data)
        
        // Then
        dump(work)
    }
    
    func testDecodeAgent() throws {
        // Given
        guard let url = Bundle.module.url(forResource: "no2008131957", withExtension: "json") else {
            XCTFail()
            return
        }
        let data = try Data(contentsOf: url)
        
        // When
        let agent = try JSONDecoder().decode(RealWorldObject.Agent.self, from: data)
        
        // Then
        XCTAssertEqual(agent.name, "Hajnoczky, Helen")
    }
    
    func testDecodeMagyarázni() throws {
        // Given
        guard let url = Bundle.module.url(forResource: "20953723", withExtension: "json") else {
            XCTFail()
            return
        }
        let data = try Data(contentsOf: url)
        
        // When
        let work = try JSONDecoder().decode(Bibframe.Work.self, from: data)
        
        // Then
        dump(work)
    }
    
    /*func testFetchResponsibilityStatements() async throws {
        let results = try await LinkedDataService.search("Jacques Derrida", count: 1000)
        var statements: [String] = []
        
        // TODO: Now all you have to do is retrieve more results
        // for result in results.prefix(10) {
        for result in results {
            let (data, _) = try await URLSession.shared.data(from: result.url)
            let instance = try JSONDecoder().decode(Instance.self, from: data)
            let statement = instance.contributors.responsibilityStatement
            if !statement.isEmpty {
                statements.append(statement)
            }
        }
        
        // TODO: Include the original ID
        
        print("===")
        for statement in statements {
            print(statement)
        }
        print("===")
    }*/
}*/
