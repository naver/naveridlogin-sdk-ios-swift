//
//  ClientInfoRepository.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

public struct ClientInfo {
    public let clientId: String
    public let clientSecret: String
    public let urlScheme: String
    public let appName: String
}

public protocol ClientInfoRepository {
    func load() throws -> ClientInfo
}
