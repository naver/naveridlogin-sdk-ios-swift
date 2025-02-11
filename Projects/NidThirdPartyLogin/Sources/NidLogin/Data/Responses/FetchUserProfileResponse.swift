//
//  FetchUserProfileResponse.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

struct FetchUserProfileResponse: Decodable, ResultCodeResponse {
    let resultCode: String
    let message: String
    let response: [String: String]?

    enum CodingKeys: String, CodingKey {
        case resultCode = "resultcode"
        case message = "message"
        case response = "response"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try container.decode(String.self, forKey: .resultCode)
        message = try container.decode(String.self, forKey: .message)
        response = try? container.decode([String: String].self, forKey: .response)
    }
}

extension FetchUserProfileResponse {
    func toDomain() -> [String: String]? {
        return response
    }
}
