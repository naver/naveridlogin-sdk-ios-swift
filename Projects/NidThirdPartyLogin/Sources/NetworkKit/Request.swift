//
//  Request.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

public enum HTTPMethod: String, Encodable {
    case get = "GET"
    case post = "POST"
}

public enum ContentType: String {
    case formUrlEncoded = "application/x-www-form-urlencoded; charset=utf-8"
    case json = "application/json"
}

public enum TokenType: String {
    case bearer = "Bearer"
}

public typealias Parameters = [String: AnyHashable]

public protocol Request: Hashable {
    associatedtype Response: Decodable

    var baseUrl: URL { get }
    var path: String { get }
    var header: HTTPHeaders { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
}

extension Request {
    func httpBody() -> Data? {
        return self.parameters.toHttpBodyString().data(using: .utf8)
    }

    func formURLEncodedHTTPBody() -> Data? {
        return self.parameters.percentEncodedString()?.data(using: .utf8)
    }
}
