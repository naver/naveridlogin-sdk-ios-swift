//
//  WebAuthCodeRepositoryTest.swift
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

final class MockWebAuthCodeRepository: WebAuthenticationService {
    enum WebAuthenticationResult {
        case userCancelled
        case userCancelledInWeb
        case generalError
        case invalidState(state: String)
        case missingState
    }

    var result: WebAuthenticationResult = .userCancelled

    func authenticate(url: URL, callbackURLScheme: String, withEphemeralSession: Bool, callback: @escaping (Result<URL, NidLogin.WebAuthenticationError>) -> Void) {
        switch result {
        case .userCancelled: callback(.failure(.userCancelled))
        case .userCancelledInWeb: callback(.success(URL(string: "myapp://page?state=randomstate&error=access_denied")!))
        case .generalError: callback(.failure(.undefined(nil)))
        case .invalidState(state: let state): callback(.success(URL(string: "myapp://page?state=\(state + "2")&code=abdde")!))
        case .missingState: callback(.success(URL(string: "myapp://page?code=abdde")!))
        }
    }
}

struct WebAuthCodeRepositoryTest {
    @Test func userCancellationTest() async throws {
        let mockWebAuthCodeRepository = MockWebAuthCodeRepository()
        mockWebAuthCodeRepository.result = .userCancelled
        let authCodeRepo = DefaultWebAuthorizationCodeRepository(authenticationService: mockWebAuthCodeRepository)

        await withCheckedContinuation { continuation in
            authCodeRepo.requestAuthCode(
                clientId: "abcd",
                clientSecret: "abcd",
                urlScheme: "myapp://",
                state: "randomstate",
                authType: .default,
                moduleVersion: "1.0.0",
                callback: { result in
                    switch result {
                    case .failure(let error):
                        #expect(error == NidError.clientError(.canceledByUser))
                        continuation.resume()
                    case .success:
                        #expect(Bool(false))
                        continuation.resume()
                    }
                }
            )
        }

        mockWebAuthCodeRepository.result = .userCancelledInWeb
        await withCheckedContinuation { continuation in
            authCodeRepo.requestAuthCode(
                clientId: "abcd",
                clientSecret: "abcd",
                urlScheme: "myapp://",
                state: "randomstate",
                authType: .default,
                moduleVersion: "1.0.0",
                callback: { result in
                    switch result {
                    case .failure(let error):
                        #expect(error == NidError.clientError(.canceledByUser))
                        continuation.resume()
                    case .success:
                        #expect(Bool(false))
                        continuation.resume()
                    }
                }
            )
        }
    }


    @Test("유효하지 않은 state가 전달될 때와, state 파라미터가 응답으로 전달되지 않았을 때 에러를 발생하는지 확인한다.")
    func invalidStateTest() async throws {
        let mockWebAuthCodeRepository = MockWebAuthCodeRepository()
        let expectedState = "abcde"
        mockWebAuthCodeRepository.result = .invalidState(state: expectedState)
        let authCodeRepo = DefaultWebAuthorizationCodeRepository(authenticationService: mockWebAuthCodeRepository)

        await withCheckedContinuation { continuation in
            authCodeRepo.requestAuthCode(
                clientId: "abcd",
                clientSecret: "abcd",
                urlScheme: "myapp://",
                state: expectedState,
                authType: .reprompt,
                moduleVersion: "1.0.0",
                callback: { result in
                    switch result {
                    case .failure(let error):
                        #expect(error == NidError.serverError(.invalidState(expected: expectedState, actual: expectedState + "2")))
                        continuation.resume()
                    case .success:
                        #expect(Bool(false))
                        continuation.resume()
                    }
                }
            )
        }

        mockWebAuthCodeRepository.result = .missingState
        await withCheckedContinuation { continuation in
            authCodeRepo.requestAuthCode(
                clientId: "abcd",
                clientSecret: "abcd",
                urlScheme: "myapp://",
                state: "",
                authType: .reprompt,
                moduleVersion: "1.0.0",
                callback: { result in
                    switch result {
                    case .failure(let error):
                        #expect(error == NidError.serverError(.invalidState(expected: "", actual: nil)))
                        continuation.resume()
                    case .success:
                        #expect(Bool(false))
                        continuation.resume()
                    }
                }
            )
        }
    }

    @Test func asWebAuthInternalErrorTest() async throws {
        let mockWebAuthCodeRepository = MockWebAuthCodeRepository()
        mockWebAuthCodeRepository.result = .generalError
        let authCodeRepo = DefaultWebAuthorizationCodeRepository(authenticationService: mockWebAuthCodeRepository)

        await withCheckedContinuation { continuation in
            authCodeRepo.requestAuthCode(
                clientId: "abcd",
                clientSecret: "abcd",
                urlScheme: "myapp://",
                state: "abcde",
                authType: .reauthenticate,
                moduleVersion: "1.0.0",
                callback: { result in
                    switch result {
                    case .failure(let error):
                        #expect(error == NidError.serverError(.webAuthenticationInternalError(nil)))
                        continuation.resume()
                    case .success:
                        #expect(Bool(false))
                        continuation.resume()
                    }
                }
            )
        }
    }
}
