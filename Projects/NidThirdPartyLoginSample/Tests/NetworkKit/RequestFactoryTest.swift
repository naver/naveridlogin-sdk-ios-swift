//
//  RequestFactoryTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
@testable import NetworkKit
import Testing

struct MockResponse: Decodable {

}

struct MockRequest: Request {
    typealias Response = MockResponse
    var baseUrl: URL = URL(string: "https://nid.naver.com")!
    var path: String = "nidlogin.login"
    var header: NetworkKit.HTTPHeaders = .init()
    var method: NetworkKit.HTTPMethod = .get
    var parameters: NetworkKit.Parameters = ["mode" : "form", "url" : "https://www.naver.com"]
}

@Suite(.serialized)
struct RequestFactoryTest {
    @Test("중복된 header 선언시 후자가 등록되는지 확인")
    func httpHeaderAdditionTest() {
        var request = MockRequest()
        request.header.add(.contentType(.formUrlEncoded))
        request.header.add(.contentType(.json))
        request.header.add(.authorization(type: .bearer, "abcdefg"))
        #expect(request.header.contains(.contentType(ContentType.formUrlEncoded.rawValue)) == false)
        #expect(request.header.contains(.contentType(ContentType.json.rawValue)))
        #expect(request.header.contains(.authorization(type: .bearer, "abcdefg")))
    }

    @Test
    func getQueryParam() throws {
        let request = MockRequest()
        let urlRequest = try RequestFactory(request: request).urlRequestRepresentation()
        let query: String

        if #available(iOS 16.0, *) {
            query = urlRequest.url!.query(percentEncoded: false)!
        } else {
            query = String(urlRequest.url!.absoluteString.split(separator: "?")[1])
        }

        let queries = query
            .split(separator: "&")
            .map{
                let result = $0.split(separator: "=")
                return (String(result[0]), String(result[1]))
            }
            .sorted { $0.0 < $1.0 }

        let revisedParameters = request.parameters
            .map { ($0.key, String(describing: $0.value)) }
            .sorted(by: { $0.0 < $1.0 })

        zip(revisedParameters, queries)
            .forEach {
                #expect(($0.0 == $1.0) && ($0.1 == $1.1))
            }
    }

    @Test
    func postHTTPBodyParam() throws {
        var request = MockRequest()
        request.method = .post
        let urlRequest = try RequestFactory(request: request).urlRequestRepresentation()

        let decodedHttpBody = String(data: urlRequest.httpBody!, encoding: .utf8)!

        let params = decodedHttpBody
            .split(separator: "&")
            .map{
                let result = $0.split(separator: "=")
                return (String(result[0]), String(result[1]))
            }
            .sorted { $0.0 < $1.0 }

        let revisedParameters = request.parameters
            .map { ($0.key, String(describing: $0.value)) }
            .sorted(by: { $0.0 < $1.0 })

        zip(revisedParameters, params)
            .forEach {
                #expect(($0.0 == $1.0) && ($0.1 == $1.1))
            }
    }
}
