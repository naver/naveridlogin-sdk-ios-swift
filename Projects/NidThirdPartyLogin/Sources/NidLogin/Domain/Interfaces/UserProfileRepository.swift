//
//  UserProfileRepository.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import NidCore

protocol UserProfileRepository {
    func fetchUserProfile(accessToken: String, callback: @escaping (Result<[String: String], NidError>) -> Void)
}
