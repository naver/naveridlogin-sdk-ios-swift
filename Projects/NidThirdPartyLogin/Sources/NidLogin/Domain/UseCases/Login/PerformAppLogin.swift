//
//  PerformAppLogin.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NidCore
import Utils

public struct PerformAppLoginRequestValue {
    let clientId: String
    let clientSecret: String
    let urlScheme: String
    let appName: String

    public init(clientId: String, clientSecret: String, urlScheme: String, appName: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.urlScheme = urlScheme
        self.appName = appName
    }
}

private enum AppAuthCode: String {
    case invalidRequest = "6"
    case unauthorizedClient = "7"
    case unsupportedResponseType = "8"
    case serverError = "9"
    case undefined = "10"

    var fullErrorCode: String {
        switch self {
        case .invalidRequest: return "invalid_request"
        case .unauthorizedClient: return "unauthorized_client"
        case .unsupportedResponseType: return "unsupported_response_type"
        case .serverError: return "server_error"
        case .undefined: return "undefined"
        }
    }

    var errorDescription: String? {
        switch self {
        case .invalidRequest: return "파라미터가 잘못되었거나 요청문이 잘못되었습니다."
        case .unauthorizedClient: return "인증받지 않은 인증 코드(authorization code)로 요청했습니다."
        case .unsupportedResponseType: return "정의되지 않은 반환 형식으로 요청했습니다."
        case .serverError: return "네이버 인증 서버의 오류로 요청을 처리하지 못했습니다."
        case .undefined: return nil
        }
    }

    public func toNidError(detail: String?) -> NidError {
        NidError.serverError(
            .authError(
                errorCode: self.fullErrorCode,
                errorDescription: self.errorDescription ?? detail)
        )
    }
}

// MARK: - Implementations
final class PerformAppLogin: PerformLoginUseCase {
    typealias ProcessType = AppLoginProcess

    struct IncomingURLKeys {
        static let authCode = "authCode"
        static let errorCode = "code"
        static let errorDescription = "error_detail"
    }

    // MARK: - Repositories
    private let authorizationCodeRepository: AppAuthorizationCodeRepository
    private let loginResultRepository: LoginResultRepository
    private let tokenRepository: TokenRepository

    // MARK: - Properties
    private var process: AppLoginProcess?
    private var callback: ((Result<LoginResult, NidError>) -> Void)?
    private lazy var saveTokenWithLoginResult: (Result<LoginResult, NidError>, String) -> Void = { [weak self] (result, clientId) in
        switch result {
        case .success(let loginResult):
            self?.save(
                accessToken: loginResult.accessToken,
                refreshToken: loginResult.refreshToken,
                clientId: clientId
            )
        case .failure(let error):
            NidLogger.log(error.localizedDescription)
        }
    }

    init(
        authorizationCodeRepository: AppAuthorizationCodeRepository,
        loginResultRepository: LoginResultRepository,
        tokenRepository: TokenRepository
    ) {
        self.authorizationCodeRepository = authorizationCodeRepository
        self.loginResultRepository = loginResultRepository
        self.tokenRepository = tokenRepository
    }

    func createAndExecuteProcess(
        requestValue: LoginRequestValue,
        callback: @escaping (Result<NidCore.LoginResult, NidError>) -> Void
    ) -> any LoginProcess {

        let process = AppLoginProcess(
            clientID: requestValue.clientId,
            clientSecret: requestValue.clientSecret,
            urlScheme: requestValue.urlScheme,
            appName: requestValue.appName,
            authType: requestValue.authType
        )

        self.process = process
        self.execute(process: process, callback: callback)
        return process
    }

    /// 들어온 Redirect URL이 네이버앱 로그인 페이지에서 넘어온 URL인지 확인하며, 맞다면 액세스 토큰을 요청한다
    func handleURL(_ url: URL) -> Bool {
        guard isNaverAppLoginRedirectURL(url), let process else {
            return false
        }

        guard let authCode = url.extract(IncomingURLKeys.authCode) else {
            if let errorCode = url.extract(IncomingURLKeys.errorCode) {
                let appAuthCode = AppAuthCode(rawValue: errorCode) ?? .undefined
                callback?(.failure(appAuthCode.toNidError(detail: url.extract(IncomingURLKeys.errorDescription))))
            } else {
                callback?(.failure(.serverError(.invalidURLResponse(url))))
            }
            return true
        }

        self.loginResultRepository.requestAccessToken(
            clientId: process.clientID,
            clientSecret: process.clientSecret,
            authCode: authCode,
            callback: { [weak self] result in
                self?.saveTokenWithLoginResult(result, process.clientID)
                self?.callback?(result)
            })

        return true
    }
}

extension PerformAppLogin {
    private func execute(
        process: AppLoginProcess,
        callback: @escaping (Result<LoginResult, NidError>) -> Void
    ) {
        self.process = process
        if AuthType.default == process.authType, let refreshToken = tokenRepository.refreshToken(for: process.clientID) {
            requestAccessTokenWithRefreshToken(
                refreshToken: refreshToken,
                process: process,
                callback: callback
            )
            return
        }

        // 앱으로 reauthenticate하는 경우 그냥 login 수행
        var updatedProcess = process
        if AuthType.reauthenticate == process.authType {
            updatedProcess = AppLoginProcess(clientID: process.clientID, clientSecret: process.clientSecret, urlScheme: process.urlScheme, appName: process.appName, authType: .default)
        }

        self.process = updatedProcess
        requestAccessTokenWithAuthCode(
            process: updatedProcess,
            callback: callback
        )
    }

    private func requestAccessTokenWithAuthCode(
        process: AppLoginProcess,
        callback: @escaping (Result<LoginResult, NidError>) -> Void
    ) {
        self.callback = callback
        authorizationCodeRepository
            .requestAuthCode(
                clientId: process.clientID,
                clientSecret: process.clientSecret,
                urlScheme: process.urlScheme,
                appName: process.appName,
                authType: process.authType,
                callback: { callback(.failure($0)) })
    }

    private func requestAccessTokenWithRefreshToken(
        refreshToken: RefreshToken,
        process: ProcessType,
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
}

extension PerformAppLogin {
    private func isNaverAppLoginRedirectURL(_ incomingURL: URL) -> Bool {
        if process?.urlScheme.lowercased() == incomingURL.scheme?.lowercased() &&
            Constant.naverAppIncomingURLPage == incomingURL.host {
            return true
        }
        return false
    }

    private func save(accessToken: AccessToken, refreshToken: RefreshToken, clientId: String) {
        do {
            try tokenRepository.updateAccessToken(forKey: clientId, accessToken)
            try tokenRepository.updateRefreshToken(forKey: clientId, refreshToken)
        } catch {
            NidLogger.log(error.localizedDescription, level: .error)
        }
    }
}
