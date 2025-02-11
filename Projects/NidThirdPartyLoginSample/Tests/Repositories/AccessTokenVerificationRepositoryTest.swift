//
//  AccessTokenVerificationRepositoryTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Testing
@testable import NidLogin
@testable import NetworkKit
import NidCore
import Foundation

extension ValidateAccessTokenResponse: @retroactive Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(resultCode, forKey: .resultCode)
        try container.encode(message, forKey: .message)
    }
}

struct ResultCodeVerificationResponse: MockResponseProtocol {
    var data: Data

    init(resultCode: String, message: String = "") {
        self.data = try! JSONEncoder().encode(
            ValidateAccessTokenResponse(
                resultCode: resultCode,
                message: message
            )
        )
    }
}

@Suite(.serialized)
struct AccessTokenVerificationRepositoryTest {
    let accessToken = "abcdefg"

    @Test
    func verificationSuccessResponseToDomainTest() async throws {
        let response = ResultCodeVerificationResponse(resultCode: "00")
        let repo = DefaultOpenAPIRepository(
            network: DefaultNetwork(
                session: MockURLSession(response: response)
            ),
            systemInfo: SystemInfo(mainEntryModel: DefaultOpenAPIRepository.self)
        )

        repo.verify(accessToken, callback: { result in
            switch result {
            case .success(let output):
                #expect(output == true)
            case .failure:
                #expect(Bool(false))
            }
        })
    }

    @Test
    func verificationFailureResponseToDomainTest() async throws {
        let response = ResultCodeVerificationResponse(resultCode: "024")
        let repo = DefaultOpenAPIRepository(
            network: DefaultNetwork(
                session: MockURLSession(response: response)
            ),
            systemInfo: SystemInfo(mainEntryModel: DefaultOpenAPIRepository.self)
        )

        repo.verify(accessToken, callback: { result in
            switch result {
            case .success(let output):
                #expect(output == false)
            case .failure:
                #expect(Bool(false))
            }
        })
    }

    @Test
    func verificationErrorResponseToDomainTest() async throws {
        let response = ResultCodeVerificationResponse(resultCode: "050")
        let repo = DefaultOpenAPIRepository(
            network: DefaultNetwork(
                session: MockURLSession(response: response)
            ),
            systemInfo: SystemInfo(mainEntryModel: DefaultOpenAPIRepository.self)
        )

        repo.verify(accessToken, callback: { result in
            switch result {
            case .success:
                #expect(Bool(false))
            case .failure(let error):
                #expect(error == NidError.serverError(.authError(errorCode: "050", errorDescription: "")))
            }
        })
    }
}
