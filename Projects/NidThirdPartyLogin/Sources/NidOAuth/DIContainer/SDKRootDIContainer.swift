//
//  SDKRootDIContainer.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit
internal import NidLogin
internal import NetworkKit

final class SDKRootDIContainer {
    lazy var webAuthenticationService: WebAuthenticationService = {
        return ASAuthenticationService()
    }()

    lazy var network: Network = {
        return DefaultNetwork()
    }()

    lazy var localStorage: PersistentStorage = {
        return DefaultStorage(
            primaryStorage: KeychainStorage(serviceName: Constant.keychainServiceName),
            secondaryStorage: MemoryStorage()
        )
    }()

    lazy var bundleDataSource: BundleDataSource = {
        return DefaultBundleDataSource()
    }()

    lazy var systemInfo: SystemInfo = {
        #if SWIFT_PACKAGE
        return SystemInfo(bundle: Bundle.module)
        #else
        return SystemInfo(mainEntryModel: NidOAuth.self)
        #endif
    }()

    func makeOAuthDIContainer() -> OAuthDIContainer {
        let dependencies = OAuthDIContainer.Dependencies(
            authenticationService: webAuthenticationService,
            network: network,
            localStorage: localStorage,
            bundleDataSource: bundleDataSource,
            systemInfo: systemInfo
        )
        return OAuthDIContainer(dependencies: dependencies)
    }
}
