//
//  SecureURL.swift
//  ReaderPrototype
//
//  Created by Ian Sampson on 2021-11-12.
//

import Foundation

extension URL {
    var secure: URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        // TODO: Check whether scheme is http or https
        components.scheme = "https"
        return components.url
    }
    
    func withScheme(_ scheme: String) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.scheme = scheme
        return components?.url
    }
}
