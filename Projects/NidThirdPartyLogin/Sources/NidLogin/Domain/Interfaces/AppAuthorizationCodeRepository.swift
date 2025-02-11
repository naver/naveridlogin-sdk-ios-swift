//
//  AppAuthorizationCodeRepository.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import NidCore

protocol AppAuthorizationCodeRepository {
    func requestAuthCode(
        clientId: String,
        clientSecret: String,
        urlScheme: String,
        appName: String,
        authType: AuthType,
        callback: @escaping (NidError) -> Void
    )
}
