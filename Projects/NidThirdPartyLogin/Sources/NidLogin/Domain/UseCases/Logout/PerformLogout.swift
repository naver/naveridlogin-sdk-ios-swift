//
//  PerformLogout.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import NidCore

public final class PerformLogout {

    private let tokenRepository: TokenRepository

    init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }

    public func execute(clientId: String) {
        do {
            try tokenRepository.removeToken(forKey: clientId)
        } catch {
            NidLogger.log(error.localizedDescription, level: .error)
        }
    }
}
