//
//  RefreshToken.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

public struct RefreshToken: Codable {
    public let tokenString: String

    public init(tokenString: String) {
        self.tokenString = tokenString
    }
}
