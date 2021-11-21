//
//  CrossRefTests.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

import Foundation
import CrossRef
import XCTest

final class CrossRefTests: XCTestCase {
    func testDecodeItem() throws {
        // Given
        let data = try Data.init(name: "0008-6215(90)84065-3", extension: "json")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromKebabCase
        decoder.dateDecodingStrategy = .iso8601
        
        // When
        let item = try decoder.decode(Work.self, from: data)
        
        // Then
        XCTAssertEqual(item.title.first, "Subject index")
    }
    
    func testRetrieveWorkWithDOI() async throws {
        // Given
        let service = Service(urlSession: .shared)
        
        // When
        let work = try await service.work(withDOI: "10.1037/0003-066X.59.1.29")
        
        // Then
        XCTAssertNotNil(work)
    }
}
