//
//  LoginResult.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

public struct LoginResult {
    public let accessToken: AccessToken
    public let refreshToken: RefreshToken

    public init(accessToken: AccessToken, refreshToken: RefreshToken) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
