//
//  AppAuthRequest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Utils
import NidCore
import NetworkKit

struct AppAuthCodeRequest: URLConvertible {
    struct AppAuthCodeRequestParameters {
        let version: String = Constant.naverAppLoginVersion
        let callbackScheme: String
        let extOauthConsumerKey: String
        let responseType: String = "code"
        let extAppName: String
        let authType: String?

        init(
            callbackScheme: String,
            extOauthConsumerKey: String,
            extAppName: String,
            authType: AuthType
        ) {
            self.callbackScheme = callbackScheme
            self.extOauthConsumerKey = extOauthConsumerKey
            self.extAppName = extAppName
            self.authType = authType.value
        }

        func params() -> [String: Any] {
            var params = [
                "version": version,
                "callbackScheme": callbackScheme,
                "extOauthConsumerKey": extOauthConsumerKey,
                "response_type": responseType,
                "extAppName": extAppName
            ]

            if let authType {
                params["authType"] = authType
            }

            return params
        }
    }

    let baseURLString: String = Constant.naverAppAuthCodeRequestURLString
    let path: [String] = []
    let parameters: [String: Any]

    init(parameters: AppAuthCodeRequestParameters) {
        self.parameters = parameters.params()
    }
}
