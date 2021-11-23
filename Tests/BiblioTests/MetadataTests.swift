//
//  MetadataTests.swift
//  
//
//  Created by Ian Sampson on 2021-11-22.
//

import XCTest
@testable import Metadata

final class MetadataTests: XCTestCase {
    func testParseHTML() throws {
        // Given
        let url = URL(string: "https://press.uchicago.edu/ucp/books/book/chicago/N/bo125517349.html")!
        let data = try Data(contentsOf: url)
        // let data = try Data(name: "10.5250%2Fquiparle.19.2.0003", extension: "html")
        // let url = URL(string: "https://read.dukeupress.edu/qui-parle/article-abstract/19/2/3/10193/Normal-Flora-and-Ambient-Microfauna")!
        
        // When
        let metadata =  try MetadataParser().parse(data, from: url)
        
        print(metadata)
    }
}
