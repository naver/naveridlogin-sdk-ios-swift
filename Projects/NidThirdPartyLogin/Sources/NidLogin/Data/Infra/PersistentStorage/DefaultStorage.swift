//
//  DefaultStorage.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NidCore

public final class DefaultStorage: PersistentStorage {
    enum CurrentDataSource {
        case primary
        case secondary
    }

    private var dataSource: PersistentStorage
    private(set) var currentDataSource: CurrentDataSource = .primary
    private let primaryStorage: PersistentStorage
    private let secondaryStorage: PersistentStorage

    public init(primaryStorage: PersistentStorage, secondaryStorage: PersistentStorage) {
        self.primaryStorage = primaryStorage
        self.secondaryStorage = secondaryStorage
        self.dataSource = primaryStorage
    }

    public func set<T>(_ value: T, forKey key: String) throws where T: StorableItem {
        try executeOperationWithOneTimeFailover { storage in
            try storage.set(value, forKey: key)
        }
    }

    public func load<T>(key: String) throws -> T? where T: StorableItem {
        try executeOperationWithOneTimeFailover { storage in
            return try storage.load(key: key)
        }
    }

    public func remove(key: String) throws {
        try executeOperationWithOneTimeFailover { storage in
            try storage.remove(key: key)
        }
    }

    private func executeOperationWithOneTimeFailover<T>(_ action: (PersistentStorage) throws -> T) throws -> T {
        do {
            return try action(dataSource)
        } catch {
            if currentDataSource == .primary {
                currentDataSource = .secondary
                dataSource = secondaryStorage
                NidLogger.log("Switched to secondary storage", level: .info)
                return try action(dataSource)
            }

            throw error
        }
    }
}
