//
//  ConfigTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import Testing
@testable import NidLogin
import NidCore



struct MockBundleDataSource: BundleDataSource {
    let values: [String: String] = [
        ConfigBundleKeys.clientId: "clientId",
        ConfigBundleKeys.clientSecret: "clientSecret",
        ConfigBundleKeys.appName: "appName",
    ]

    func value<T>(for key: String) -> T? {
        return values[key] as? T
    }
}

struct ConfigTest {
    let repository = DefaultClientInfoRepository(bundleDataSource: MockBundleDataSource())

    @Test
    func clientConfigurationMissing() {
        let expectedError = NidError.clientError(.missingClientConfiguration(key: ConfigBundleKeys.urlScheme))
        #expect(throws: expectedError) {
            try repository.load()
        }
    }
}
