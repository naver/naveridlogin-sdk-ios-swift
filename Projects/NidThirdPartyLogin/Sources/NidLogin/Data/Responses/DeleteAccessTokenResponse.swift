//
//  DeleteAccessTokenResponse.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

struct DeleteAccessTokenResponse: Decodable, ResultResponse {
    typealias Success = DeleteAccessTokenSuccessResponse
    typealias Failure = CommonTokenFailureResponse
    let successResponse: Success?
    let failureResponse: Failure?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case result = "result"
        case errorCode = "error"
        case description = "error_description"
    }

    init(successResponse: Success) {
        self.successResponse = successResponse
        self.failureResponse = nil
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // errorCode 존재 유무로 successResponse 생성할지 failureResponse 생성할지 판단
        if container.contains(.errorCode) {
            failureResponse = try CommonTokenFailureResponse(from: decoder)
            successResponse = nil
        } else {
            successResponse = try DeleteAccessTokenSuccessResponse(from: decoder)
            failureResponse = nil
        }
    }
}

struct DeleteAccessTokenSuccessResponse: Decodable, SuccessResponse {
    let accessToken: String
    let result: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case result = "result"
    }

    init(accessToken: String, result: String) {
        self.accessToken = accessToken
        self.result = result
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        result = try container.decode(String.self, forKey: .result)
    }
}
