//
//  SecureURL.swift
//  ReaderPrototype
//
//  Created by Ian Sampson on 2021-11-12.
//

import Foundation

extension URL {
    var secure: URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.scheme = "https"
        return components.url
    }
}
