//
//  DefaultWebAuthorizationCodeRepository.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Utils
import NidCore
import AuthenticationServices
import NetworkKit

final class DefaultWebAuthorizationCodeRepository: WebAuthorizationCodeRepository {
    private let authenticationService: WebAuthenticationService
    private let systemInfo: SystemInfo

    init(authenticationService: WebAuthenticationService, systemInfo: SystemInfo) {
        self.authenticationService = authenticationService
        self.systemInfo = systemInfo
    }

    func requestAuthCode(
        clientId: String,
        clientSecret: String,
        urlScheme: String,
        state: String,
        authType: AuthType,
        callback: @escaping (Result<(authCode: String, state: String), NidError>) -> Void
    ) {
        let webAuthCodeRequest = WebAuthCodeRequest(
            parameters: .init(
                clientId: clientId,
                urlScheme: urlScheme,
                state: state,
                locale: Language.current ?? "",
                oauthOS: UIDevice.currentOS,
                authType: authType,
                moduleVersion: systemInfo.currentModuleVersion
            )
        )

        guard let authCodeRequestURL = URLGenerator.generateURL(webAuthCodeRequest) else {
            callback(.failure(.clientError(.invalidClientConfigurationFormat)))
            return
        }

        let openWebCompletion: (Result<URL, WebAuthenticationError>) -> Void = { result in
            switch result {
            case .failure(let error):
                switch error {
                case .userCancelled: callback(.failure(.clientError(.canceledByUser)))
                case .undefined(let error): callback(.failure(.serverError(.webAuthenticationInternalError(error))))
                }
            case .success(let url):
                guard let stateResult = url.extract("state") else {
                    callback(.failure(.serverError(.invalidState(expected: state, actual: nil))))
                    return
                }

                guard stateResult == state else {
                    callback(.failure(.serverError(.invalidState(expected: state, actual: stateResult))))
                    return
                }

                if let error = url.extract("error") {
                    if error == "access_denied" {
                        callback(.failure(.clientError(.canceledByUser)))
                    } else {
                        callback(.failure(.serverError(
                            .authError(errorCode: error, errorDescription: url.extract("error_description"))
                        )))
                    }
                    return
                }

                guard let authCode = url.extract("code") else {
                    callback(.failure(.serverError(.invalidURLResponse(url))))
                    return
                }

                callback(.success((authCode, state)))
            }
        }

        authenticationService
            .authenticate(
                url: authCodeRequestURL,
                callbackURLScheme: urlScheme,
                withEphemeralSession: false,
                callback: openWebCompletion
            )
    }
}
