//
//  HTTPHeaders.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

public struct HTTPHeaders: Equatable, Hashable {
    private var headers: Set<HTTPHeader> = []
    public init() {}

    public init(_ dict: [String: String]) {
        dict.forEach {
            add(.init(key: $0.key, value: $0.value))
        }
    }

    public init(_ headers: [HTTPHeader]) {
        for header in headers {
            add(header)
        }
    }

    public var dictionary: [String: String] {
        let headerKeyValuePair = headers.map { ($0.key, $0.value) }
        return Dictionary(headerKeyValuePair, uniquingKeysWith: { _, last in return last })
    }
}

extension HTTPHeaders {
    public func with(_ header: HTTPHeader) -> HTTPHeaders {
        var newHeaders = self
        newHeaders.add(header)
        return newHeaders
    }

    public mutating func add(_ header: HTTPHeader) {
        add(key: header.key, value: header.value)
    }

    public mutating func add(key: String, value: String) {
        headers.update(with: .init(key: key, value: value))
    }

    public func contains(_ header: HTTPHeader) -> Bool {
        return headers.first(where: { $0.key == header.key && $0.value == header.value }) != nil
    }

    public func containsByKey(_ header: HTTPHeader) -> Bool {
        return headers.contains(header)
    }

    public func value(_ header: HTTPHeader) -> HTTPHeader? {
        return headers.first(where: { $0.key == header.key && $0.value == header.value })
    }

    public func valueByKey(_ header: HTTPHeader) -> HTTPHeader? {
        return headers.first(where: { $0 == header })
    }
}

extension URLRequest {
    public var headers: HTTPHeaders {
        get { allHTTPHeaderFields.map(HTTPHeaders.init) ?? HTTPHeaders() }
        set { allHTTPHeaderFields = newValue.dictionary }
    }
}
