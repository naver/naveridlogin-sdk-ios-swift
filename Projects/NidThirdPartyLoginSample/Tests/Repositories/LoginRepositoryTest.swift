//
//  LoginRepositoryTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Testing
@testable import NidCore
@testable import NidLogin
@testable import NetworkKit
import Foundation

struct UnsupportedResponse: MockResponseProtocol {
    var data: Data

    init(value: String) {
        self.data = value.data(using: .utf8)!
    }
}

extension IssueAccessTokenResponse: @retroactive Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let successResponse = successResponse {
            try container.encodeIfPresent(successResponse.accessToken, forKey: .accessToken)
            try container.encodeIfPresent(successResponse.tokenType, forKey: .tokenType)
            try container.encodeIfPresent(successResponse.expiresIn, forKey: .expiresIn)
            try container.encodeIfPresent(successResponse.refreshToken, forKey: .refreshToken)
        }

        if let failureResponse = failureResponse {
            try container.encodeIfPresent(failureResponse.errorCode, forKey: .errorCode)
            try container.encodeIfPresent(failureResponse.description, forKey: .description)
        }
    }
}

struct DeleteTokenSuccessResponse: MockResponseProtocol {
    var data: Data

    init(accessToken: String, result: String) {
        let successResponse = DeleteAccessTokenResponse(successResponse: .init(accessToken: accessToken, result: result))
        self.data = try! JSONEncoder().encode(successResponse)
    }
}

extension DeleteAccessTokenResponse: @retroactive Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let successResponse = successResponse {
            try container.encodeIfPresent(successResponse.accessToken, forKey: .accessToken)
            try container.encodeIfPresent(successResponse.result, forKey: .result)
        }

        if let failureResponse = failureResponse {
            try container.encodeIfPresent(failureResponse.errorCode, forKey: .errorCode)
            try container.encodeIfPresent(failureResponse.description, forKey: .description)
        }
    }
}

struct ErrorResponse: MockResponseProtocol {
    var data: Data

    init(errorCode: String, description: String? = nil) {
        let failureResponse = CommonTokenFailureResponse(errorCode: errorCode, description: description)
        self.data = try! JSONEncoder().encode(IssueAccessTokenResponse(failureResponse: failureResponse))
    }
}

struct LoginRepositoryTest {
    @Test func requestAccessTokenFailureTest() async throws {
        let urlSession = MockURLSession(
            response: ErrorResponse(
                errorCode: "404"
            )
        )

        urlSession.networkResult = .shouldReturn404FailureStatusCode
        let repo = DefaultLoginResultRepository(
            network: DefaultNetwork(
                session: urlSession
            ),
            systemInfo: SystemInfo(mainEntryModel: DefaultLoginResultRepository.self)
        )

        await withCheckedContinuation { continuation in
            repo.requestAccessToken(clientId: "abcde", clientSecret: "dfkjsdf", authCode: "rerererer", callback: { result in
                switch result {
                case .success:
                    #expect(Bool(false))
                    continuation.resume()
                case .failure(let error):
                    let expectedError = NidError.serverError(.authError(errorCode: "404", errorDescription: nil))
                    #expect(error == expectedError)
                    continuation.resume()
                }
            })
        }
    }

    @Test func updateAccessTokenWithNotValidRefreshToken() async throws {
        let urlSession = MockURLSession(response: ErrorResponse(errorCode: "invalid_request", description: "invalid refresh_token"))
        urlSession.networkResult = .shouldReturnSuccesStatusCode
        let repo = DefaultLoginResultRepository(
            network: DefaultNetwork(
                session: urlSession
            ),
            systemInfo: SystemInfo(mainEntryModel: DefaultLoginResultRepository.self)
        )

        await withCheckedContinuation { continuation in
            repo.updateAccessToken(clientId: "abcd", clientSecret: "abcd", refreshToken: .init(tokenString: "invalidRefreshToken"), callback: { result in
                switch result {
                case .success:
                    #expect(Bool(false))
                    continuation.resume()
                case .failure(let error):
                    let expectedError = NidError.serverError(.authError(errorCode: "invalid_request", errorDescription: "invalid refresh_token"))
                    #expect(error == expectedError)
                    continuation.resume()
                }
            })
        }
    }


    @Test
    func revokeOAuthConnectionSuccess() async throws {
        let atRawString = "abcAX23/+="
        let urlSession = MockURLSession(response: DeleteTokenSuccessResponse(accessToken: atRawString, result: "success"))
        urlSession.networkResult = .shouldReturnSuccesStatusCode
        let repo = DefaultLoginResultRepository(
            network: DefaultNetwork(
                session: urlSession
            ),
            systemInfo: SystemInfo(mainEntryModel: DefaultLoginResultRepository.self)
        )

        await withCheckedContinuation { continuation in
            repo.revokeOAuthConnection(clientId: "abcd", clientSecret: "abcd", accessToken: atRawString, callback: { result in
                switch result {
                case .success(let atRawStringResponse):
                    #expect(atRawStringResponse == atRawString)
                    continuation.resume()
                case .failure:
                    #expect(Bool(false))
                    continuation.resume()
                }
            })
        }
    }
}
