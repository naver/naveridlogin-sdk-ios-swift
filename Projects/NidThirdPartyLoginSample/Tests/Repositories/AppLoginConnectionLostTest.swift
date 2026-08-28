//
//  AppLoginConnectionLostTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Testing
import Foundation
import UIKit
@testable import NetworkKit
@testable import NidCore
@testable import NidLogin

// MARK: - Stubs

private struct StubAppAuthCodeRepository: AppAuthorizationCodeRepository {
    func requestAuthCode(
        clientId: String,
        clientSecret: String,
        urlScheme: String,
        appName: String,
        authType: AuthType,
        presentingViewController: UIViewController?,
        callback: @escaping (NidError) -> Void
    ) {}
}

private struct StubTokenRepository: TokenRepository {
    func accessToken(for: String) -> AccessToken? { nil }
    func refreshToken(for: String) -> RefreshToken? { nil }
    func updateAccessToken(forKey: String, _ accessToken: AccessToken) throws {}
    func updateRefreshToken(forKey: String, _ refreshToken: RefreshToken) throws {}
    func removeToken(forKey: String) throws {}
}

/// 첫 호출만 지정된 오류로 실패하고 이후는 성공하는 스텁. `callCount` 로 토큰 교환 시도 횟수를 센다.
private final class SequencedLoginResultRepository: LoginResultRepository {
    private let firstFailure: NidError
    private(set) var callCount = 0

    init(firstFailure: NidError) {
        self.firstFailure = firstFailure
    }

    func requestAccessToken(
        clientId: String,
        clientSecret: String,
        authCode: String,
        callback: @escaping (Result<LoginResult, NidError>) -> Void
    ) {
        callCount += 1
        guard callCount > 1 else {
            return callback(.failure(firstFailure))
        }
        callback(.success(
            LoginResult(
                accessToken: AccessToken(expiresIn: 3600, tokenString: "at"),
                refreshToken: RefreshToken(tokenString: "rt")
            )
        ))
    }

    func updateAccessToken(
        clientId: String,
        clientSecret: String,
        refreshToken: RefreshToken,
        callback: @escaping (Result<LoginResult, NidError>) -> Void
    ) {}

    func revokeOAuthConnection(
        clientId: String,
        clientSecret: String,
        accessToken: String,
        callback: @escaping (Result<String, NidError>) -> Void
    ) {}
}

// MARK: - Tests

/// 네이버앱 복귀 후 토큰 교환이 커넥션 유실로 실패했을 때의 동작 검증. (GitHub 이슈 #6)
struct AppLoginConnectionLostTest {
    private static let urlScheme = "nidoauthsampleapp"

    private static func networkError(code: Int) -> NidError {
        .serverError(.networkError(
            NetworkError.urlSessionInternalError(error: NSError(domain: NSURLErrorDomain, code: code))
        ))
    }

    /// 네이버앱이 넘겨준 콜백 URL 을 흉내낸다.
    private static var incomingURL: URL {
        URL(string: "\(urlScheme)://\(Constant.naverAppIncomingURLPage)?authCode=authCode")!
    }

    private func login(firstFailure: NidError) async -> (succeeded: Bool, attempts: Int) {
        let loginResultRepository = SequencedLoginResultRepository(firstFailure: firstFailure)
        let performAppLogin = PerformAppLogin(
            authorizationCodeRepository: StubAppAuthCodeRepository(),
            loginResultRepository: loginResultRepository,
            tokenRepository: StubTokenRepository()
        )

        let succeeded: Bool = await withCheckedContinuation { continuation in
            _ = performAppLogin.createAndExecuteProcess(
                requestValue: LoginRequestValue(
                    clientId: "clientId",
                    clientSecret: "clientSecret",
                    urlScheme: Self.urlScheme,
                    appName: "appName"
                ),
                callback: { continuation.resume(returning: (try? $0.get()) != nil) }
            )
            _ = performAppLogin.handleURL(Self.incomingURL)
        }

        return (succeeded, loginResultRepository.callCount)
    }

    /// 인가코드를 다시 받지 않고 토큰 교환만 다시 쏘아 복구한다. 네이버앱은 다시 실행되지 않는다.
    @Test
    func retriesTokenExchangeOnConnectionLost() async {
        let result = await login(firstFailure: Self.networkError(code: NSURLErrorNetworkConnectionLost))

        #expect(result.succeeded)
        #expect(result.attempts == 2)
    }

    @Test
    func doesNotRetryOnOtherError() async {
        let result = await login(firstFailure: Self.networkError(code: NSURLErrorTimedOut))

        #expect(result.succeeded == false)
        #expect(result.attempts == 1)
    }
}
