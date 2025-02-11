//
//  URLGenerator.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

public protocol URLConvertible {
    var baseURLString: String { get }
    var path: [String] { get }
    var parameters: [String: Any] { get }
}

final public class URLGenerator {
    static public func generateURL(_ urlConvertible: URLConvertible) -> URL? {
        return generateURLWithPercentEncoded(
            baseURLString: urlConvertible.baseURLString,
            paths: urlConvertible.path,
            queries: urlConvertible.parameters
        )
    }

    static func generateURLWithPercentEncoded(
        baseURLString: String,
        paths: [String],
        queries: [String: Any]
    ) -> URL? {

        let urlString = baseURLString + paths.joined(separator: "/")
        guard var components = URLComponents(string: urlString) else {
            return nil
        }

        let urlEncodedQueryString = queries.map { key, value in
            let encodedValue = String(describing: value).percentEncoded() ?? "\(value)"
            return "\(key)=\(encodedValue)"
        }.joined(separator: "&")

        components.percentEncodedQuery = urlEncodedQueryString

        return components.url
    }
}
