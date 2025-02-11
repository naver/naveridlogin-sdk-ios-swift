//
//  WebAuthCodeRequest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import Utils
import NidCore
import NetworkKit

struct WebAuthCodeRequest: URLConvertible {
    struct AuthCodeRequestParameters {
        let clientId: String
        let responseType: String = "code"
        let redirectURI: String
        let state: String
        let locale: String
        let oauthOS: String
        let version: String
        let authType: String?

        init(
            clientId: String,
            urlScheme: String,
            state: String,
            locale: String,
            oauthOS: String,
            authType: AuthType,
            moduleVersion: String
        ) {
            self.clientId = clientId
            self.redirectURI = urlScheme + "://authorize"
            self.state = state
            self.locale = locale
            self.oauthOS = oauthOS
            self.authType = authType.value
            self.version = "ios-\(moduleVersion)"
        }

        func params() -> [String: Any] {
            var params = [
                "client_id": clientId,
                "response_type": responseType,
                "redirect_uri": redirectURI,
                "state": state,
                "locale": locale,
                "oauth_os": oauthOS,
                "version": version
            ]

            if let authType {
                params["auth_type"] = authType
            }

            return params
        }
    }

    let baseURLString: String = Constant.nidOAuth20BaseURL.absoluteString
    let path: [String] = [Constant.nidOAuth20Path]
    let parameters: [String: Any]

    init(parameters: AuthCodeRequestParameters) {
        self.parameters = parameters.params()
    }
}
