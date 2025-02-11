//
//  BundleDataSource.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//
import UIKit
import NidCore

public protocol BundleDataSource {
    func value<T>(for key: String) -> T?
}

/// Main bundle로부터 데이터를 가져오는 datasource
public final class DefaultBundleDataSource: BundleDataSource {
    private lazy var _bundle: Bundle = .main
    private lazy var infoDictionary: [String: Any] = {
        guard let infoDictionary = _bundle.infoDictionary else {
            NidLogger.fatalError("Info.plist not found in bundle")
        }

        return infoDictionary
    }()

    public init() {}

    public func value<T>(for key: String) -> T? {
        return infoDictionary[key] as? T
    }
}
