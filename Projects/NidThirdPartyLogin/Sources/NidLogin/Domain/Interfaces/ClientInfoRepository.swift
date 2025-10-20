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

    public init(
        clientId: String,
        clientSecret: String,
        urlScheme: String,
        appName: String
    ) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.urlScheme = urlScheme
        self.appName = appName
    }
}

public protocol ClientInfoRepository {
    func load() throws -> ClientInfo
    func save(_ clientInfo: ClientInfo)
}
