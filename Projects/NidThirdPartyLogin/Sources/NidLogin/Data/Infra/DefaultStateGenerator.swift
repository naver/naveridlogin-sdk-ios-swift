//
//  DefaultStateGenerator.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

protocol StateGenerator {
    func generate() -> String
}

struct DefaultStateGenerator: StateGenerator {
    struct Constant {
        static let stateLength: Int = 32
    }

    func generate() -> String {
        return Data
            .generateRandomBytes(length: Constant.stateLength)
            .base64EncodedString()
    }
}
