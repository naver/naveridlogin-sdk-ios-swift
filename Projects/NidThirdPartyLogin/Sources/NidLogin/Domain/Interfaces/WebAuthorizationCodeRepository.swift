//
//  WebAuthorizationCodeRepository.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import NidCore

protocol WebAuthorizationCodeRepository {
    func requestAuthCode(
        clientId: String,
        clientSecret: String,
        urlScheme: String,
        state: String,
        authType: AuthType,
        callback: @escaping (Result<(authCode: String, state: String), NidError>) -> Void
    )
}
