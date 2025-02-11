//
//  AccessTokenWithAuthCodeRequest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NetworkKit
import Utils
import NidCore

struct IssueAccessTokenRequest: Request {
    typealias Response = IssueAccessTokenResponse

    let baseUrl: URL = Constant.nidOAuth20BaseURL
    let path: String = "token"
    let header: NetworkKit.HTTPHeaders
    let method: NetworkKit.HTTPMethod = .post
    let parameters: NetworkKit.Parameters

    init(clientId: String, clientSecret: String, authCode: String, userAgent: String) {
        let parameters = [
            "grant_type": GrantType.authorizationCode.rawValue,
            "client_id": clientId,
            "client_secret": clientSecret,
            "code": authCode
        ]

        self.parameters = parameters
        self.header = .init()
            .with(.contentType(.formUrlEncoded))
            .with(.userAgent(userAgent))
    }
}
