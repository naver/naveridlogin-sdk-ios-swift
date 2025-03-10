//
//  NidOAuth.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit
internal import Utils
internal import NidLogin
@_exported import NidCore

public class NidOAuth {
    // MARK: - Model
    private struct Config {
        let clientID: String
        let clientSecret: String
        let appName: String
        let urlScheme: String
    }

    /// 로그인 결과를 반환하는 콜백입니다.
    /// 성공하는 경우 `LoginResult`가  반환되며, 실패하는 경우 `NidError`가 반환됩니다.
    ///
    public typealias LoginResultCompletion = (Result<LoginResult, NidError>) -> Void

    // MARK: - Properties
    /// `NidOAuth`의 싱글톤 인스턴스를 반환합니다.
    ///
    public static let shared: NidOAuth = NidOAuth()
    private lazy var config: Config = {
        return loadConfig()
    }()

    /// 현재 설정된 로그인 방식을 반환합니다.
    /// 기본값은 `.appPreferredWithInAppBrowserFallback` 입니다.
    ///
    private(set) var behavior: LoginBehavior = .appPreferredWithInAppBrowserFallback
    private var isReady: Bool = false

    // MARK: - UseCases
    private let performInitialSetUp: PerformInitialSetUp
    private let performLogin: PerformLogin
    private let fetchClientInfo: FetchClientInfo
    private let fetchToken: FetchToken
    private let performLogout: PerformLogout
    private let disconnectAccount: DisconnectAccount
    private let verifyAccessToken: VerifyAccessToken
    private let fetchUserProfile: FetchUserProfile

    // MARK: - Initializer
    private init() {
        let dependencies: OAuthDIContainer
        dependencies = SDKRootDIContainer().makeOAuthDIContainer()
        self.performLogin = dependencies.makePerformLogin()
        self.fetchClientInfo = dependencies.makeFetchClientInfo()
        self.fetchToken = dependencies.makeFetchToken()
        self.performLogout = dependencies.makePerformLogout()
        self.disconnectAccount = dependencies.makeDisconnectAccount()
        self.verifyAccessToken = dependencies.makeVerifyAccessToken()
        self.fetchUserProfile = dependencies.makeFetchUserProfile()
        self.performInitialSetUp = dependencies.makePerformInitialSetUp()
    }

    private func loadConfig() -> Config {
        guard isReady else {
            NidLogger.fatalError(NidError.clientError(.initalizeNotCalled))
        }

        let clientInfo = fetchClientInfo.execute()
        return Config(
            clientID: clientInfo.clientId,
            clientSecret: clientInfo.clientSecret,
            appName: clientInfo.appName,
            urlScheme: clientInfo.urlScheme
        )
    }

    // MARK: - Public Interfaces
    /// 현재 AccessToken을 반환합니다.
    ///
    public var accessToken: AccessToken? {
        return fetchToken.accessToken(clientId: config.clientID)
    }

    /// 현재 RefreshToken을 반환합니다.
    ///
    public var refreshToken: RefreshToken? {
        return fetchToken.refreshToken(clientId: config.clientID)
    }

    /// 로그인 방식을 설정합니다.
    ///  - Parameters:
    ///   - behavior: 지정할 로그인 방식
    ///
    public func setLoginBehavior(_ behavior: LoginBehavior) {
        self.behavior = behavior
    }

    /// NidOAuth를 초기화합니다.
    /// `NidOAuth`를 사용하기 전에, `AppDelegate`의 `didfinishlaunchingWithOptions`에서 호출해야 합니다.
    ///
    public func initialize() {
        performInitialSetUp.prepare()
        self.isReady = true
    }

    /// 네이버로 로그인 요청을 수행합니다.
    /// - Parameters:
    ///     - callback: 로그인 결과를 반환하는 콜백
    ///
    public func requestLogin(callback: @escaping LoginResultCompletion) {
        let requestValue = LoginRequestValue(
            clientId: config.clientID,
            clientSecret: config.clientSecret,
            urlScheme: config.urlScheme,
            appName: config.appName
        )

        requestLogin(requestValue: requestValue, callback: callback)
    }

    /// 네이버앱에서 들어온 콜백 URL을 처리합니다.
    /// `SceneDelegate`의 `openURLContexts` 혹은 `AppDelegate`의 `openURL`에서 호출합니다.
    /// - Parameters:
    ///     - url: 처리할 콜백 URL
    /// - Returns: `NidOAuth`가 처리해야하는 URL이며 처리가 완료되었을 때 `true`, 그렇지 않은 경우 `false`를 반환
    ///
    public func handleURL(_ url: URL) -> Bool {
        return performLogin.handleURL(url)
    }

    /// 로그아웃을 수행합니다.
    /// 클라이언트에 저장된 토큰 정보를 삭제합니다.
    ///
    public func logout() {
        performLogout.execute(clientId: config.clientID)
    }

    /// 연동 해제를 수행합니다.
    /// 클라이언트와 서버에 저장된 토큰 정보를 삭제합니다.
    /// - Parameters:
    ///    - callback: 연동 해제 결과를 반환하는 콜백. 연동 해제에 실패하는 경우 `Result`로 에러가 반환됩니다.
    /// - Note:
    /// 로그인 상태가 아닐 때 연동 해제를 호출하더라도 `Result`로 성공이 반환됩니다.
    ///
    public func disconnect(callback: @escaping (Result<Void, NidError>) -> Void) {
        disconnectAccount.execute(
            clientId: config.clientID,
            clientSecret: config.clientSecret,
            accessToken: accessToken,
            callback: callback
        )
    }

    /// 사용자에게 프로필 항목 접근 권한 동의를 재요청합니다.
    /// - Parameters:
    ///   - callback: 권한 재요청 결과를 반환하는 콜백
    ///
    public func repromptPermissions(callback: @escaping LoginResultCompletion) {
        let requestValue = LoginRequestValue(
            clientId: config.clientID,
            clientSecret: config.clientSecret,
            urlScheme: config.urlScheme,
            appName: config.appName,
            authType: .reprompt
        )

        requestLogin(
            requestValue: requestValue,
            callback: callback
        )
    }

    /// 사용자에게 다시 한번 인증을 수행하게끔합니다.
    /// - Parameters:
    ///     - callback: 재인증 결과를 반환하는 콜백
    ///
    public func reauthenticate(callback: @escaping LoginResultCompletion) {
        let requestValue = LoginRequestValue(
            clientId: config.clientID,
            clientSecret: config.clientSecret,
            urlScheme: config.urlScheme,
            appName: config.appName,
            authType: .reauthenticate
        )

        requestLogin(
            requestValue: requestValue,
            callback: callback
        )
    }

    /// AccessToken의 유효성을 검증합니다.
    /// - Parameters:
    ///    - accessToken: 검증할 AccessToken 값
    ///    - callback: 검증 결과를 반환하는 콜백으로, 유효한 경우 `true`, 그렇지 않은 경우 `false`를 반환합니다.
    /// - Note:
    ///  LoginResult로 받은 `AccessToken`혹은 `NidOAuth`의 `accessToken`의 `tokenString`을 인자로 넘겨야 합니다.
    ///
    public func verifyAccessToken(_ accessToken: String, callback: @escaping (Result<Bool, NidError>) -> Void) {
        verifyAccessToken.execute(accessToken: accessToken, callback: callback)
    }

    /// 사용자의 프로필 정보를 가져옵니다.
    /// - Parameters:
    ///    - accessToken: 프로필 정보를 가져오는 데에 필요한 AccessToken 값
    ///    - callback: 프로필 정보를 반환하는 콜백으로, 프로필 항목 이름이 key, 값이 value인 Dictionary를 반환합니다.
    /// - Note:
    ///  LoginResult로 받은 `AccessToken`혹은 `NidOAuth`의 `accessToken`의 `tokenString`을 인자로 넘겨야 합니다.
    ///
    public func getUserProfile(accessToken: String, callback: @escaping (Result<[String: String], NidError>) -> Void) {
        fetchUserProfile.execute(accessToken: accessToken, callback: callback)
    }
}

// MARK: - Private Methods
extension NidOAuth {
    private func requestLogin(requestValue: LoginRequestValue, callback: @escaping LoginResultCompletion) {
        performLogin.execute(
            using: shouldUseApp() ? .naverApp : .inAppBrowser,
            requestValue: requestValue,
            callback: callback
        )
    }

    private func shouldUseApp() -> Bool {
        return behavior == .app || (behavior == .appPreferredWithInAppBrowserFallback && isNaverAppInstalled())
    }


    private func isNaverAppInstalled() -> Bool {
        UIApplication.shared.canOpenURLScheme("\(Constant.naverAppThirdLoginScheme)://")
    }
}
