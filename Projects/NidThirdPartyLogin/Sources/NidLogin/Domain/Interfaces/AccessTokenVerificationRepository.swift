//
//  AccessTokenVerificationRepository.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import NidCore

public protocol AccessTokenVerificationRepository {
    func verify(_ accessToken: String, callback: @escaping (Result<Bool, NidError>) -> Void)
}
