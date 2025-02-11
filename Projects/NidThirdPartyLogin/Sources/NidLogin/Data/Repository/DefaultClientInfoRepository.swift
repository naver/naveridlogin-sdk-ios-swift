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
    private let bundleDataSource: BundleDataSource

    init(bundleDataSource: BundleDataSource) {
        self.bundleDataSource = bundleDataSource
    }

    func load() throws -> ClientInfo {
        return ClientInfo(
            clientId: try loadValue(forKey: ConfigBundleKeys.clientId),
            clientSecret: try loadValue(forKey: ConfigBundleKeys.clientSecret),
            urlScheme: try loadValue(forKey: ConfigBundleKeys.urlScheme),
            appName: try loadValue(forKey: ConfigBundleKeys.appName)
        )
    }

    private func loadValue(forKey key: String) throws -> String {
        guard let value: String = bundleDataSource.value(for: key) else {
            throw NidError.clientError(.missingClientConfiguration(key: key))
        }

        return value
    }
}
