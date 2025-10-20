//
//  FetchClientInfo.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import NidCore

public final class ManageClientInfo {
    private let clientInfoRepository: ClientInfoRepository

    init(clientInfoRepository: ClientInfoRepository) {
        self.clientInfoRepository = clientInfoRepository
    }

    public func load() -> ClientInfo {
        do {
            return try clientInfoRepository.load()
        } catch {
            NidLogger.fatalError(error)
        }
    }

    public func save(clientInfo: ClientInfo) {
        clientInfoRepository.save(clientInfo)
    }
}
