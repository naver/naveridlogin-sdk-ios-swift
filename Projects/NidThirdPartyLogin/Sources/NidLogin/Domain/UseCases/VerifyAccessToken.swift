//
//  VerifyAccessToken.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NidCore

public final class VerifyAccessToken {
    let accessTokenVerificationRepository: AccessTokenVerificationRepository

    public init(accessTokenVerificationRepository: AccessTokenVerificationRepository) {
        self.accessTokenVerificationRepository = accessTokenVerificationRepository
    }

    public func execute(accessToken: String, callback: @escaping (Result<Bool, NidError>) -> Void) {
        accessTokenVerificationRepository.verify(accessToken, callback: callback)
    }
}
