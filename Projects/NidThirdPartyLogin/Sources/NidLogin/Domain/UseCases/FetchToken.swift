//
//  FetchToken.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NidCore

public final class FetchToken {
    private let tokenRepository: TokenRepository

    public init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }

    public func accessToken(clientId: String) -> AccessToken? {
        return tokenRepository.accessToken(for: clientId)
    }

    public func refreshToken(clientId: String) -> RefreshToken? {
        return tokenRepository.refreshToken(for: clientId)
    }
}
