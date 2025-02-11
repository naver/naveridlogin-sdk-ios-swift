//
//  IssueAccessTokenResponse.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NidCore

// MARK: - IssueAccessTokenResponse
/// - NOTE: HTTPStatusCode가 200일때도 에러가 존재할 수 있기 때문에, Response를 성공과 실패 2가지로 분류.
///
struct IssueAccessTokenResponse: Decodable, ResultResponse {
    typealias Success = IssueAccessTokenSuccessResponse
    typealias Failure = CommonTokenFailureResponse
    let successResponse: Success?
    let failureResponse: Failure?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case errorCode = "error"
        case description = "error_description"
    }

    init(successResponse: Success) {
        self.successResponse = successResponse
        self.failureResponse = nil
    }

    init(failureResponse: Failure) {
        self.failureResponse = failureResponse
        self.successResponse = nil
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // errorCode 존재 유무로 successResponse 생성할지 failureResponse 생성할지 판단
        if container.contains(.errorCode) {
            failureResponse = try CommonTokenFailureResponse(from: decoder)
            successResponse = nil
        } else {
            successResponse = try IssueAccessTokenSuccessResponse(from: decoder)
            failureResponse = nil
        }
    }
}

// MARK: - IssueAccessTokenSuccessResponse
struct IssueAccessTokenSuccessResponse: Decodable, SuccessResponse {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }

    init(accessToken: String, tokenType: String, expiresIn: Int, refreshToken: String) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.refreshToken = refreshToken
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)

        // expiresIn이 String으로 내려와서 Int로 변환
        let expiresInString = try container.decode(String.self, forKey: .expiresIn)
        guard let expiresInInt = Int(expiresInString) else {
            throw DecodingError.typeMismatch(
                Int.self,
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Expected String convertible to Int"
                )
            )
        }
        expiresIn = expiresInInt
    }
}

extension IssueAccessTokenSuccessResponse {
    func toDomain() -> LoginResult {
        let accessToken = AccessToken(expiresIn: self.expiresIn, tokenString: self.accessToken)
        let refreshToken = RefreshToken(tokenString: self.refreshToken)
        return LoginResult(accessToken: accessToken, refreshToken: refreshToken)
    }
}

// MARK: - AccessTokenFailureResponse
struct CommonTokenFailureResponse: Decodable, FailureResponse {
    let errorCode: String
    let description: String?

    enum CodingKeys: String, CodingKey {
        case errorCode = "error"
        case description = "error_description"
    }
}
