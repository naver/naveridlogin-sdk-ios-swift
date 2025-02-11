//
//  StateVerificationTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import Testing
@testable import NidLogin
@testable import NidThirdPartyLogin

final class MockAuthorizationCodeRepo: WebAuthorizationCodeRepository {
    var state: String?
    var callback: ((Result<(authCode: String, state: String), NidCore.NidError>) -> Void)?

    init() {}

    func requestAuthCode(clientId: String, clientSecret: String, urlScheme: String, state: String, authType: NidLogin.AuthType, moduleVersion: String, callback: @escaping (Result<(authCode: String, state: String), NidCore.NidError>) -> Void) {
        // 최초 process에 대해서만 저장
        if (self.state == nil) && (self.callback == nil) {
            self.callback = callback
            self.state = state
        }
    }

    func didChangeCurrentProcess() {
        callback?(.success(("authCode", state!)))
    }
}

final class StateVerificationTest {
    private var currentProcess: WebLoginProcess?
    private var previousProcess: WebLoginProcess?

    @Test("웹 로그인 요청 진행중인 상태에서, 한번 더 웹 로그인했을 때 이전 로그인 요청에 대하여 state가 다른 에러가 오는지 확인")
    func stateVerificationTest() async {
        let authCodeRepo = MockAuthorizationCodeRepo()

        let webLogin = PerformWebLogin(
            authorizationCodeRepository: authCodeRepo,
            loginResultRepository: MockLoginRepository(),
            tokenRepository: DefaultTokenRepository(dataSource: KeychainStorage(serviceName: "Test")),
            stateGenerator: DefaultStateGenerator()
        )

        let requestValue = LoginRequestValue(clientId: "", clientSecret: "", urlScheme: "", appName: "", moduleVersion: "")

        await withCheckedContinuation { continuation in
            self.previousProcess = (webLogin.createAndExecuteProcess(
                requestValue: requestValue,
                callback: { [weak self] result in
                    self?.checkStateResult(result)
                    continuation.resume()
                }
            ) as! WebLoginProcess)

            self.currentProcess = (webLogin.createAndExecuteProcess(
                requestValue: requestValue,
                callback: { _ in
                }
            ) as? WebLoginProcess)

            authCodeRepo.didChangeCurrentProcess()
        }
    }

    private func checkStateResult(_ result: Result<LoginResult, NidError>) {
        switch result {
        case .success:
            #expect(Bool(false), "This test should throw an error.")
        case .failure(let error):
            #expect(error == NidError.serverError(
                .invalidState(expected: currentProcess!.state, actual: previousProcess!.state)
            ))
        }
    }
}

struct MockLoginRepository: LoginResultRepository {
    func requestAccessToken(clientId: String, clientSecret: String, authCode: String, callback: @escaping (Result<NidCore.LoginResult, NidCore.NidError>) -> Void) {
        return
    }

    func updateAccessToken(clientId: String, clientSecret: String, refreshToken: NidCore.RefreshToken, callback: @escaping (Result<NidCore.LoginResult, NidCore.NidError>) -> Void) {
        return
    }

    func revokeOAuthConnection(clientId: String, clientSecret: String, accessToken: String, callback: @escaping (Result<String, NidCore.NidError>) -> Void) {
        return
    }
}
