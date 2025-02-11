//
//  ValidateAccessTokenRequest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NetworkKit
import NidCore

struct ValidateAccessTokenRequest: Request {
    typealias Response = ValidateAccessTokenResponse
    let baseUrl: URL = Constant.nidOpenAPIBaseURL
    let path: String = "verify"
    let header: NetworkKit.HTTPHeaders
    let method: NetworkKit.HTTPMethod = .get
    let parameters: NetworkKit.Parameters = [:]

    init(accessToken: String, userAgent: String) {
        self.header = .init()
            .with(.authorization(type: .bearer, accessToken))
            .with(.userAgent(userAgent))
    }
}
