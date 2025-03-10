//
//  PerformWebLogin.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NidCore

// MARK: - Implementations
final class PerformWebLogin: PerformLoginUseCase {
    typealias ProcessType = WebLoginProcess

    // MARK: - Repositories
    private let authorizationCodeRepository: WebAuthorizationCodeRepository
    private let loginResultRepository: LoginResultRepository
    private let tokenRepository: TokenRepository
    private let stateGenerator: StateGenerator

    // MARK: - Properties
    private var process: ProcessType?
    private lazy var saveTokenWithLoginResult:
    (Result<LoginResult, NidError>, String) -> Void = { [weak self] (result, clientId) in
        switch result {
        case .success(let loginResult):
            self?.save(
                accessToken: loginResult.accessToken,
                refreshToken: loginResult.refreshToken,
                clientId: clientId
            )
        case .failure(let error):
            NidLogger.log(error.localizedDescription, level: .error)
        }
    }

    init(
        authorizationCodeRepository: WebAuthorizationCodeRepository,
        loginResultRepository: LoginResultRepository,
        tokenRepository: TokenRepository,
        stateGenerator: StateGenerator
    ) {
        self.authorizationCodeRepository = authorizationCodeRepository
        self.loginResultRepository = loginResultRepository
        self.tokenRepository = tokenRepository
        self.stateGenerator = stateGenerator
    }

    func createAndExecuteProcess(
        requestValue: LoginRequestValue,
        callback: @escaping (Result<LoginResult, NidError>) -> Void
    ) -> any LoginProcess {

        let process = WebLoginProcess(
            clientID: requestValue.clientId,
            clientSecret: requestValue.clientSecret,
            urlScheme: requestValue.urlScheme,
            state: stateGenerator.generate(),
            authType: requestValue.authType
        )

        self.process = process
        self.execute(process: process, callback: callback)

        return process
    }
}

extension PerformWebLogin {
    private func execute(
        process: ProcessType,
        callback: @escaping (Result<LoginResult, NidError>) -> Void
    ) {

        if AuthType.default == process.authType, let refreshToken = tokenRepository.refreshToken(for: process.clientID) {
            requestAccessTokenWithRefreshToken(
                refreshToken: refreshToken,
                process: process,
                callback: callback
            )
        } else {
            requestAccessTokenWithAuthCode(
                process: process,
                callback: callback
            )
        }
    }

    private func requestAccessTokenWithAuthCode(
        process: ProcessType,
        callback: @escaping (Result<LoginResult, NidError>) -> Void
    ) {
        let requestATWithAuthCode: (Result<(authCode: String, state: String), NidError>) -> Void = { [weak self] result in
            switch result {
            case .success((let authCode, let incomingState)):
                guard let process = self?.process else { return }
                guard self?.isValidState(incomingState) == true else {
                    callback(.failure(
                        NidError.serverError(.invalidState(expected: process.state, actual: incomingState))
                    ))
                    return
                }

                self?.loginResultRepository.requestAccessToken(
                    clientId: process.clientID,
                    clientSecret: process.clientSecret,
                    authCode: authCode,
                    callback: {
                        self?.saveTokenWithLoginResult($0, process.clientID)
                        callback($0)
                    }
                )
            case .failure(let error):
                callback(.failure(error))
            }
        }

        authorizationCodeRepository.requestAuthCode(
            clientId: process.clientID,
            clientSecret: process.clientSecret,
            urlScheme: process.urlScheme,
            state: process.state,
            authType: process.authType,
            callback: requestATWithAuthCode
        )
    }

    private func requestAccessTokenWithRefreshToken(
        refreshToken: RefreshToken,
        process: WebLoginProcess,
        callback: @escaping (Result<LoginResult, NidError>) -> Void
    ) {
        loginResultRepository.updateAccessToken(
            clientId: process.clientID,
            clientSecret: process.clientSecret,
            refreshToken: refreshToken,
            callback: { [weak self] result in
                switch result {
                case .success:
                    self?.saveTokenWithLoginResult(result, process.clientID)
                    callback(result)
                case .failure:
                    // update failover시, requestAccessToken로 한번 더 AT 발급 시도
                    DispatchQueue.main.async {
                        self?.requestAccessTokenWithAuthCode(
                            process: process,
                            callback: callback
                        )
                    }
                }
            }
        )
    }

    private func save(accessToken: AccessToken, refreshToken: RefreshToken, clientId: String) {
        do {
            try tokenRepository.updateAccessToken(forKey: clientId, accessToken)
            try tokenRepository.updateRefreshToken(forKey: clientId, refreshToken)
        } catch {
            NidLogger.log(error.localizedDescription, level: .error)
        }
    }

    private func isValidState(_ incomingState: String) -> Bool {
        return process?.state == incomingState
    }
}
