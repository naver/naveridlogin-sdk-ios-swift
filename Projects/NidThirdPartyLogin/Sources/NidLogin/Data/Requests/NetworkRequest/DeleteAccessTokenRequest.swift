//
//  DeleteAccessTokenRequest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//
import Foundation
import NetworkKit
import NidCore

struct DeleteAccessTokenRequest: Request {
    typealias Response = DeleteAccessTokenResponse

    let baseUrl: URL = Constant.nidOAuth20BaseURL
    let path: String = "token"
    let header: NetworkKit.HTTPHeaders
    let method: NetworkKit.HTTPMethod = .post
    let parameters: NetworkKit.Parameters

    init(clientId: String, clientSecret: String, accessToken: String, userAgent: String) {
        let parameters = [
            "grant_type": GrantType.delete.rawValue,
            "client_id": clientId,
            "client_secret": clientSecret,
            "access_token": accessToken,
            "service_provider": "NAVER"
        ]

        self.parameters = parameters
        self.header = .init()
            .with(.contentType(.formUrlEncoded))
            .with(.userAgent(userAgent))
    }
}
