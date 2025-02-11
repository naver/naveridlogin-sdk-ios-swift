//
//  AccessToken.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//
import Foundation

public struct AccessToken: Codable {
    public let tokenString: String
    public let expiresAt: Date
    public var isExpired: Bool {
        expiresAt < Date()
    }

    public init(expiresIn: Int, tokenString: String) {
        self.tokenString = tokenString
        self.expiresAt = Date().addingTimeInterval(TimeInterval(expiresIn))
    }

    public init(expiresAt: Date, tokenString: String) {
        self.tokenString = tokenString
        self.expiresAt = expiresAt
    }
}
