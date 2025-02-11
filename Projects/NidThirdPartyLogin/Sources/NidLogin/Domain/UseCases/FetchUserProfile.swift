//
//  FetchUserProfile.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NidCore

public final class FetchUserProfile {
    private let userProfileRepository: UserProfileRepository

    init(userProfileRepository: UserProfileRepository) {
        self.userProfileRepository = userProfileRepository
    }

    public func execute(accessToken: String, callback: @escaping (Result<[String: String], NidError>) -> Void) {
        userProfileRepository.fetchUserProfile(accessToken: accessToken, callback: callback)
    }
}
