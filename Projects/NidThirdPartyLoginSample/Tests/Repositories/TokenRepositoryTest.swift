//
//  TokenRepositoryTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Testing
@testable import NidLogin
import NidCore
import Foundation

@Suite(.serialized)
class TokenRepositoryTest {
    let tokenRepository = DefaultTokenRepository(
        dataSource: KeychainStorage(serviceName: "nidthirdpartylogin.keychainstorage")
    )

    let clientIdKey = "clientIdKey"

    init() throws {
        try tokenRepository.removeToken(forKey: clientIdKey)
    }

    deinit {
        try? tokenRepository.removeToken(forKey: clientIdKey)
    }

    @Test("최초로 액세스 토큰과 리프레시 토큰을 저장하고 이후 불러왔을 때 잘 가져와지는지 확인")
    func accessTokenAndRefreshTokenRetrival() throws {
        try #require(tokenRepository.accessToken(for: clientIdKey) == nil)
        try #require(tokenRepository.refreshToken(for: clientIdKey) == nil)

        let accessToken = AccessToken(expiresIn: 100, tokenString: "mockAccessTokenString1")
        try tokenRepository.updateAccessToken(forKey: clientIdKey, accessToken)

        let refreshToken = RefreshToken(tokenString: "mockRefreshTokenString1")
        try tokenRepository.updateRefreshToken(forKey: clientIdKey, refreshToken)

        #expect(tokenRepository.accessToken(for: clientIdKey) != nil && tokenRepository.accessToken(for: clientIdKey)!.tokenString == accessToken.tokenString)
        #expect(tokenRepository.refreshToken(for: clientIdKey) != nil && tokenRepository.refreshToken(for: clientIdKey)!.tokenString == refreshToken.tokenString)
    }


    @Test("액세스 토큰과 리프레시 토큰 삭제가 잘 작동하는지 확인. 저장된 AT나 RT가 없을 때도 에러를 던지지 않는지 확인")
    func accessTokenAndRefreshDeletion() throws {
        let accessToken = AccessToken(expiresIn: 100, tokenString: "mockAccessTokenString1")
        try tokenRepository.updateAccessToken(forKey: clientIdKey, accessToken)

        let refreshToken = RefreshToken(tokenString: "mockRefreshTokenString1")
        try tokenRepository.updateRefreshToken(forKey: clientIdKey, refreshToken)

        try #require(tokenRepository.accessToken(for: clientIdKey) != nil)
        try #require(tokenRepository.refreshToken(for: clientIdKey) != nil)
        try tokenRepository.removeToken(forKey: clientIdKey)

        #expect(tokenRepository.accessToken(for: clientIdKey) == nil)
        #expect(tokenRepository.refreshToken(for: clientIdKey) == nil)
        try tokenRepository.removeToken(forKey: clientIdKey)
    }
}

fileprivate struct MockLoginResultRepository: LoginResultRepository {
    public let rt = RefreshToken(
        tokenString: "abcdefghikjFakeRefreshToken"
    )

    // request더라도 무조건 update로 수행
    func requestAccessToken(clientId: String, clientSecret: String, authCode: String, callback: @escaping (Result<NidCore.LoginResult, NidError>) -> Void) {
        updateAccessToken(
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: rt,
            callback: callback
        )
    }

    func updateAccessToken(clientId: String, clientSecret: String, refreshToken: NidCore.RefreshToken, callback: @escaping (Result<NidCore.LoginResult, NidError>) -> Void) {
        let at = AccessToken(
            expiresAt: .init(),
            tokenString: UUID().uuidString
        )

        let loginResult = LoginResult(
            accessToken: at,
            refreshToken: rt
        )

        callback(.success(loginResult))
    }

    func revokeOAuthConnection(clientId: String, clientSecret: String, accessToken: String, callback: @escaping (Result<String, NidError>) -> Void) {

    }
}

struct MockAppAuthCodeRepo: AppAuthorizationCodeRepository {
    func requestAuthCode(
        clientId: String,
        clientSecret: String,
        urlScheme: String,
        appName: String,
        authType: AuthType,
        callback: @escaping (NidError) -> Void
    ) {
        return
    }
}

struct MockWebAuthCodeRepo: WebAuthorizationCodeRepository {
    func requestAuthCode(
        clientId: String,
        clientSecret: String,
        urlScheme: String,
        state: String,
        authType: AuthType,
        callback: @escaping (Result<(authCode: String, state: String), NidError>) -> Void
    ) {
        return
    }
}

extension TokenRepositoryTest {
    @Test("앱에서 AT 갱신 후, 현재 AT를 가져왔을 때 갱신된 값과 동일한지 확인한다. 새로 가져온 AT가 키체인에 잘 업데이트되는지 확인하기 위함.")
    func updateAccessTokenWithAppAndCheckCurrentAccessToken() throws {
        let tokenRepository = DefaultTokenRepository(
            dataSource: KeychainStorage(serviceName: "nidthirdpartylogin.keychainstorage")
        )

        let fetchTokenUseCase = FetchToken(
            tokenRepository: tokenRepository
        )

        let loginResultrepository = MockLoginResultRepository()
        let appLoginUseCase = PerformAppLogin(
            authorizationCodeRepository: MockAppAuthCodeRepo(),
            loginResultRepository: loginResultrepository,
            tokenRepository: tokenRepository
        )

        try tokenRepository.updateRefreshToken(forKey: "rtKey", loginResultrepository.rt)
        _ = appLoginUseCase.createAndExecuteProcess(
            requestValue: .init(
                clientId: "mockClientID",
                clientSecret: "mockClientSecret",
                urlScheme: "mockUrlScheme",
                appName: "MyMockAppName"
            ), callback: { result in
                switch result {
                case .success(let loginResult):
                    let atFromCallback = loginResult.accessToken
                    let atFromStorage = fetchTokenUseCase.accessToken(clientId: "mockClientID")!
                    print(atFromStorage.tokenString)
                    #expect(atFromCallback.tokenString == atFromStorage.tokenString)
                case .failure(let error):
                    debugPrint(error)
                    #expect(Bool(false))
                }
            })
    }

    @Test("웹에서 AT 갱신 후, 현재 AT를 가져왔을 때 갱신된 값과 동일한지 확인한다. 새로 가져온 AT가 키체인에 잘 업데이트되는지 확인하기 위함.")
    func updateAccessTokenWithWebAndCheckCurrentAccessToken() throws {
        let tokenRepository = DefaultTokenRepository(
            dataSource: KeychainStorage(serviceName: "nidthirdpartylogin.keychainstorage")
        )

        let fetchTokenUseCase = FetchToken(
            tokenRepository: tokenRepository
        )

        let loginResultrepository = MockLoginResultRepository()
        let webLoginUseCase = PerformWebLogin(
            authorizationCodeRepository: MockWebAuthCodeRepo(),
            loginResultRepository: loginResultrepository,
            tokenRepository: tokenRepository,
            stateGenerator: DefaultStateGenerator()
        )

        tokenRepository.updateRefreshToken(forKey: "refreshTokenKey", loginResultrepository.rt)
        _ = webLoginUseCase.createAndExecuteProcess(
            requestValue: .init(
                clientId: "mockClientID",
                clientSecret: "mockClientSecret",
                urlScheme: "mockUrlScheme",
                appName: "mockAppName"
            ),
            callback: { result in
                switch result {
                case .success(let loginResult):
                    let atFromCallback = loginResult.accessToken
                    let atFromStorage = fetchTokenUseCase.accessToken(clientId: "mockClientID")!
                    print(atFromStorage.tokenString)
                    #expect(atFromCallback.tokenString == atFromStorage.tokenString)
                case .failure(let error):
                    debugPrint(error)
                    #expect(Bool(false))
                }
            })
    }
}
