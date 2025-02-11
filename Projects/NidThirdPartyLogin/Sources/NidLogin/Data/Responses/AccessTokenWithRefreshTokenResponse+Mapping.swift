//
//  AccessTokenWithRefreshTokenResponse.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NidCore

struct UpdateAccessTokenResponse: Decodable, ResultResponse {
    typealias Success = UpdateAccessTokenSuccessResponse
    typealias Failure = CommonTokenFailureResponse
    let successResponse: Success?
    let failureResponse: Failure?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case errorCode = "error"
        case description = "error_description"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // errorCode 존재 유무로 successResponse 생성할지 failureResponse 생성할지 판단
        if container.contains(.errorCode) {
            failureResponse = try CommonTokenFailureResponse(from: decoder)
            successResponse = nil
        } else {
            successResponse = try UpdateAccessTokenSuccessResponse(from: decoder)
            failureResponse = nil
        }
    }
}

struct UpdateAccessTokenSuccessResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)

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

extension UpdateAccessTokenSuccessResponse: SuccessResponse {

    func toDomain(refreshToken: RefreshToken) -> LoginResult {
        let accessToken = AccessToken(expiresIn: self.expiresIn, tokenString: self.accessToken)
        return LoginResult(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
