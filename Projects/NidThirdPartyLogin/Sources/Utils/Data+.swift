//
//  Data+.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

extension Data {
    public static func generateRandomBytes(length: Int) -> Data {
        let bytes: [UInt8] = (0..<length)
            .map { _ in UInt8.random(in: UInt8.min...UInt8.max)}
        return Data(bytes)
    }
}
