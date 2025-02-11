//
//  TokenRepository.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import NidCore

public protocol TokenRepository {
    func accessToken(for: String) -> AccessToken?
    func refreshToken(for: String) -> RefreshToken?
    func updateAccessToken(forKey: String, _ accessToken: AccessToken) throws
    func updateRefreshToken(forKey: String, _ refreshToken: RefreshToken) throws
    func removeToken(forKey: String) throws
}
