//
//  PercentEncodingTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Testing
import NetworkKit

enum SpecialCharacters: String, CaseIterable {
    case needPercentEncoding = "+?=&"
    case noNeedPercentEncoding = ":/"

    var expectation: String {
        switch self {
        case .needPercentEncoding:
            return "%2B%3F%3D%26"
        case .noNeedPercentEncoding:
            return ":/"
        }
    }
}

struct PercentEncodingTest {
    @Test("적절한 특수문자들이 퍼센트 인코딩 되는지 확인한다.", arguments: SpecialCharacters.allCases)
    func percentEncodingTests(targets: SpecialCharacters) {
        let params = ["value" : targets.rawValue]
        let mockRequest = MockUrlConvertibleRequest(params: params)
        let url = URLGenerator.generateURL(mockRequest)!
        let queryparams = url.absoluteString.split(separator: "?")[1].split(separator: "&")

        let result = Dictionary(uniqueKeysWithValues: queryparams.map {
            let param = $0.split(separator: "=")
            return (String(param[0]), String(param[1]))
        })

        #expect(result["value"] == targets.expectation)
    }
}


struct MockUrlConvertibleRequest: URLConvertible {
    var baseURLString: String = "https://www.test.com"

    var path: [String] = []

    var parameters: [String : Any]

    init(params: [String: Any]) {
        self.parameters = params
    }
}
