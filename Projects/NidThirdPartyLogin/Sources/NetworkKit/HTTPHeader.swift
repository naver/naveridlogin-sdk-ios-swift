//
//  HTTPHeader.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

public struct HTTPHeader: Equatable, Hashable {
    public let key: String
    public let value: String

    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }

    public static func == (lhs: HTTPHeader, rhs: HTTPHeader) -> Bool {
        return lhs.key == rhs.key
    }
}

extension HTTPHeader: CustomStringConvertible {
    public var description: String {
        "\(key): \(value)"
    }
}

extension HTTPHeader {
    public static func contentType(_ value: String) -> HTTPHeader {
        return HTTPHeader(key: "Content-Type", value: value)
    }

    public static func contentType(_ contentType: ContentType) -> HTTPHeader {
        return HTTPHeader(key: "Content-Type", value: contentType.rawValue)
    }

    public static func userAgent(_ value: String) -> HTTPHeader {
        return HTTPHeader(key: "User-Agent", value: value)
    }

    public static func authorization(type: TokenType, _ value: String) -> HTTPHeader {
        return HTTPHeader(key: "Authorization", value: "\(type.rawValue) \(value)")
    }
}
