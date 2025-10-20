//
//  DefaultClientInfoRepository.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import NidCore
import Foundation

final class DefaultClientInfoRepository: ClientInfoRepository {
    private var clientInfo: ClientInfo?

    func load() throws -> ClientInfo {
        guard let clientInfo else {
            throw NidError.clientError(.missingClientConfiguration)
        }
        return clientInfo
    }

    func save(_ clientInfo: ClientInfo) {
        self.clientInfo = clientInfo
    }
}
