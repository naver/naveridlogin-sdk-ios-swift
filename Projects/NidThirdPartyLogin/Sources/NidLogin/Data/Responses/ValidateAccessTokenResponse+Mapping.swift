//
//  ValidateAccessTokenResponse.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

struct ValidateAccessTokenResponse: Decodable, ResultCodeResponse {
    let resultCode: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case resultCode = "resultcode"
        case message = "message"
    }
}

extension ValidateAccessTokenResponse {
    func toDomain() -> Bool? {
        if resultCode == "00" {
            return true
        } else if resultCode == "024" {
            return false
        }

        return nil
    }
}
