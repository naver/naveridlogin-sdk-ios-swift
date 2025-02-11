//
//  Dictionary+PercentEncoding.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

extension Dictionary where Key: CustomStringConvertible, Value: CustomStringConvertible {
    func toHttpBodyString() -> String {
        return map { key, value in
            return "\(key)=\(value)"
        }
        .joined(separator: "&")
    }

    func percentEncodedString() -> String? {
        return map { key, value in
            let escapedKey = key.description
                .addingPercentEncoding(withAllowedCharacters: .allowedCharacterSet()) ?? "\(key.description)"
            let escapedValue = value.description
                .addingPercentEncoding(withAllowedCharacters: .allowedCharacterSet()) ?? "\(value.description)"
            return "\(escapedKey)=\(escapedValue)"
        }
        .joined(separator: "&")
    }
}
