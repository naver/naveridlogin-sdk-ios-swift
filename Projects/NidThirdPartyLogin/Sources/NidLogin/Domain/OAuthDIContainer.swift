//
//  OAuthDIContainer.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import NetworkKit

public final class OAuthDIContainer {
    public struct Dependencies {
        let authenticationService: WebAuthenticationService
        let network: Network
        let localStorage: PersistentStorage
        let bundleDataSource: BundleDataSource
        let systemInfo: SystemInfo

        public init(
            authenticationService: WebAuthenticationService,
            network: Network,
            localStorage: PersistentStorage,
            bundleDataSource: BundleDataSource,
            systemInfo: SystemInfo
        ) {
            self.authenticationService = authenticationService
            self.network = network
            self.localStorage = localStorage
            self.bundleDataSource = bundleDataSource
            self.systemInfo = systemInfo
        }
    }

    private let dependencies: Dependencies
    private lazy var tokenRepository: DefaultTokenRepository = {
        DefaultTokenRepository(dataSource: dependencies.localStorage)
    }()

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - Use Cases
extension OAuthDIContainer {
    public func makePerformLogin() -> PerformLogin {
        PerformLogin(
            performWebLogin: makePerformWebLogin(),
            performAppLogin: makePerformAppLogin()
        )
    }

    private func makePerformWebLogin() -> PerformWebLogin {
        return PerformWebLogin(
            authorizationCodeRepository: makeAuthCodeRepository(),
            loginResultRepository: makeLoginResultRepository(),
            tokenRepository: makeTokenRepository(),
            stateGenerator: makeStateGenerator()
        )
    }

    private func makePerformAppLogin() -> PerformAppLogin {
        return PerformAppLogin(
            authorizationCodeRepository: makeAppAuthCodeRepository(),
            loginResultRepository: makeLoginResultRepository(),
            tokenRepository: makeTokenRepository()
        )
    }

    public func makeFetchClientInfo() -> FetchClientInfo {
        return FetchClientInfo(clientInfoRepository: makeClientInfoRepository())
    }

    public func makeFetchToken() -> FetchToken {
        return FetchToken(tokenRepository: makeTokenRepository())
    }

    public func makePerformLogout() -> PerformLogout {
        return PerformLogout(tokenRepository: makeTokenRepository())
    }

    public func makeDisconnectAccount() -> DisconnectAccount {
        return DisconnectAccount(
            performLogout: makePerformLogout(),
            loginResultRepository: makeLoginResultRepository()
        )
    }

    public func makeVerifyAccessToken() -> VerifyAccessToken {
        return VerifyAccessToken(
            accessTokenVerificationRepository: makeAPIRepository()
        )
    }

    public func makeFetchUserProfile() -> FetchUserProfile {
        return FetchUserProfile(
            userProfileRepository: makeAPIRepository()
        )
    }

    public func makePerformInitialSetUp() -> PerformInitialSetUp {
        return PerformInitialSetUp(listeners: [makeTokenRepository()], userStateRepository: makeUserStateRepository())
    }
}

// MARK: - Repositories
extension OAuthDIContainer {
    private func makeClientInfoRepository() -> ClientInfoRepository {
        return DefaultClientInfoRepository(bundleDataSource: dependencies.bundleDataSource)
    }

    private func makeAppAuthCodeRepository() -> AppAuthorizationCodeRepository {
        return DefaultAppAuthorizationCodeRepository()
    }

    private func makeUserStateRepository() -> UserStateRepository {
        return DefaultuserStateRepository(persistentStorage: UserDefaultsStorage())
    }

    private func makeAuthCodeRepository() -> WebAuthorizationCodeRepository {
        return DefaultWebAuthorizationCodeRepository(
            authenticationService: dependencies.authenticationService,
            systemInfo: dependencies.systemInfo
        )
    }

    private func makeLoginResultRepository() -> LoginResultRepository {
        return DefaultLoginResultRepository(network: dependencies.network, systemInfo: dependencies.systemInfo)
    }

    private func makeTokenRepository() -> DefaultTokenRepository {
        return self.tokenRepository
    }

    private func makeStateGenerator() -> DefaultStateGenerator {
        return DefaultStateGenerator()
    }

    private func makeAPIRepository() -> DefaultOpenAPIRepository {
        return DefaultOpenAPIRepository(network: dependencies.network, systemInfo: dependencies.systemInfo)
    }
}
