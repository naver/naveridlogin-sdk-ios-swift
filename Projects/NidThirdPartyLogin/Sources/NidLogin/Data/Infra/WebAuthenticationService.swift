//
//  DefaultWebAuthenticationPresentationProvider.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit
import NidCore
import AuthenticationServices

public protocol WebAuthenticationService {
    func authenticate(
        url: URL,
        callbackURLScheme: String,
        withEphemeralSession: Bool,
        callback: @escaping (Result<URL, WebAuthenticationError>) -> Void)
}

public enum WebAuthenticationError: Error, CustomStringConvertible {
    case userCancelled
    case undefined(Error?)

    public var description: String {
        switch self {
        case .userCancelled:
            return "User cancelled the authentication process."
        case .undefined(let error):
            return "\(String(describing: error))"
        }
    }
}

public final class ASAuthenticationService: WebAuthenticationService {
    private var currentSession: ASWebAuthenticationSession?
    private let presentationContextProvider: ASWebAuthenticationPresentationContextProviding

    public init() {
        self.presentationContextProvider = DefaultWebAuthenticationPresentationProvider()
    }

    public func authenticate(
        url: URL,
        callbackURLScheme: String,
        withEphemeralSession: Bool,
        callback: @escaping (Result<URL, WebAuthenticationError>) -> Void) {

        self.currentSession = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: callbackURLScheme
        ) { (url, error) in
            if let error {
                if case ASWebAuthenticationSessionError.canceledLogin = error {
                    callback(.failure(WebAuthenticationError.userCancelled))
                } else {
                    callback(.failure(WebAuthenticationError.undefined(error)))
                }
                return
            }

            guard let url = url else {
                callback(.failure(WebAuthenticationError.undefined(nil)))
                return
            }

            callback(.success(url))
        }

        currentSession?.presentationContextProvider = presentationContextProvider
        currentSession?.prefersEphemeralWebBrowserSession = withEphemeralSession
        currentSession?.start()
    }
}

final class DefaultWebAuthenticationPresentationProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.keyWindow() ?? ASPresentationAnchor()
    }
}
