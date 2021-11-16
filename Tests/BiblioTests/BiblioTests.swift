//
//  BiblioTests.swift
//
//
//  Created by Ian Sampson on 2021-11-15.
//

import XCTest
import Biblio

final class BiblioTests: XCTestCase {
    func testSearch() async throws {
        // Given
        let library = Library()
        
        // When
        let instances = try await library.search(for: "Helen Hajnoczky")
        
        // Then
        guard let firstInstance = instances.first else {
            XCTFail()
            return
        }
        
        print(firstInstance.title)
        print(firstInstance.subtitle)
        print(firstInstance.contributors)
        print(firstInstance.imageURL)
    }
}
