//
//  URLSessionProtocol.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

public protocol URLSessionProtocol {
    typealias DataTaskResult = @Sendable (Data?, URLResponse?, Error?) -> Void

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping DataTaskResult
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
