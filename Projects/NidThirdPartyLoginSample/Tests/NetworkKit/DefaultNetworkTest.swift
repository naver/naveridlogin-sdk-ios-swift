//
//  DefaultNetworkTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Testing
import Foundation
@testable import NetworkKit

// URLSession이 내려줄 응답
struct ResponseData: MockResponseProtocol {
    var data: Data = Data()
}

// DummyRequest에 대한 응답
struct DummyResponse: Decodable {
    let randomKey: String
}

struct DummyRequest: Request {
    typealias Response = DummyResponse

    var baseUrl: URL = URL(string: "https://nid.naver.com")!
    var path: String = "nidlogin.login"
    var header: NetworkKit.HTTPHeaders = .init()
    var method: NetworkKit.HTTPMethod = .get
    var parameters: NetworkKit.Parameters = ["mode" : "form", "url" : "https://www.naver.com"]
}

extension NetworkError: @retroactive Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.errorDescription == rhs.errorDescription
    }
}

final class DefaultNetworkTest {
    let urlSession = MockURLSession(response: ResponseData())
    lazy var network = DefaultNetwork(session: urlSession)

    @Test
    func decodingErrorThrownTest() {
        let request = DummyRequest()
        urlSession.networkResult = .shouldReturnSuccesStatusCode
        network.send(
            request,
            completion: { result in
                switch result {
                case .success:
                    #expect(Bool(false))
                case .failure(let error):
                    let expectedError = NetworkError.decodingFailed(
                        data:ResponseData().data,
                        to: DummyResponse.self
                    )
                    #expect(error == expectedError)
                }
            }
        )
    }
}
