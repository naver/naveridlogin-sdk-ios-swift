//
//  PerformLogin.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NidCore

public final class PerformLogin {
    // MARK: - Models
    public enum LoginChannel {
        case naverApp
        case inAppBrowser
    }

    // MARK: - UseCases
    private let performWebLogin: PerformWebLogin
    private let performAppLogin: PerformAppLogin

    // MARK: - Properties
    private var currentProcess: LoginProcess?

    // MARK: - Initializers
    init(performWebLogin: PerformWebLogin, performAppLogin: PerformAppLogin) {
        self.performWebLogin = performWebLogin
        self.performAppLogin = performAppLogin
    }

    // MARK: - Methods
    public func execute(
        using loginChannel: LoginChannel,
        requestValue: LoginRequestValue,
        callback: @escaping (Result<LoginResult, NidError>) -> Void
    ) {

        let currentLoginUseCase: any PerformLoginUseCase
        switch loginChannel {
        case .inAppBrowser: currentLoginUseCase = performWebLogin
        case .naverApp: currentLoginUseCase = performAppLogin
        }

        self.currentProcess = currentLoginUseCase.createAndExecuteProcess(
            requestValue: requestValue,
            callback: callback
        )
    }

    public func handleURL(_ url: URL) -> Bool {
        performAppLogin.handleURL(url)
    }
}
