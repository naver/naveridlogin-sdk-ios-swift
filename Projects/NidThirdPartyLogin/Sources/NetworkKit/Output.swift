//
//  Output.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

public struct Output<T: Decodable & Sendable>: Sendable {
    public let response: T
    public let statusCode: Int
}
