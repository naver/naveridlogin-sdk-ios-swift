//
//  DisconnectAccount.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NidCore

public final class DisconnectAccount {
    private let performLogout: PerformLogout
    private let loginResultRepository: LoginResultRepository

    init(
        performLogout: PerformLogout,
        loginResultRepository: LoginResultRepository
    ) {
        self.performLogout = performLogout
        self.loginResultRepository = loginResultRepository
    }

    public func execute(
        clientId: String,
        clientSecret: String,
        accessToken: AccessToken?,
        callback: @escaping (Result<Void, NidError>) -> Void
    ) {
        guard let accessToken else {
            NidLogger.log("No Access Token", level: .info)
            callback(.success(()))
            return
        }

        self.loginResultRepository.revokeOAuthConnection(
            clientId: clientId,
            clientSecret: clientSecret,
            accessToken: accessToken.tokenString,
            callback: { [weak self] result in
                switch result {
                case .success:
                    self?.performLogout.execute(clientId: clientId)
                    callback(.success(()))
                case .failure(let error):
                    callback(.failure(error))
                }
            }
        )
    }
}
