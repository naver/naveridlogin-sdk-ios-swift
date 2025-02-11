//
//  LoginResultRepository.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import NidCore

protocol LoginResultRepository {
    func requestAccessToken(
        clientId: String,
        clientSecret: String,
        authCode: String,
        callback: @escaping (Result<LoginResult, NidError>) -> Void
    )

    func updateAccessToken(
        clientId: String,
        clientSecret: String,
        refreshToken: RefreshToken,
        callback: @escaping (Result<LoginResult, NidError>) -> Void
    )

    func revokeOAuthConnection(
        clientId: String,
        clientSecret: String,
        accessToken: String,
        callback: @escaping (Result<String, NidError>) -> Void
    )
}
