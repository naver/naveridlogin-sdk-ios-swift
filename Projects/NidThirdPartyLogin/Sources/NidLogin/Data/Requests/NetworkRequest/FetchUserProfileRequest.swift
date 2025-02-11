//
//  FetchUserProfileRequest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NidCore
import NetworkKit

struct FetchUserProfileRequest: Request {
    typealias Response = FetchUserProfileResponse
    let baseUrl: URL = Constant.nidOpenAPIBaseURL
    let path: String = "me"
    let header: NetworkKit.HTTPHeaders
    let method: NetworkKit.HTTPMethod = .get
    let parameters: NetworkKit.Parameters = [:]

    init(accessToken: String) {
        self.header = .init().with(.authorization(type: .bearer, accessToken))
    }
}
