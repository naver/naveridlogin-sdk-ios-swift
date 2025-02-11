//
//  MemoryStorage.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//
import Foundation

public final class MemoryStorage: PersistentStorage {
    var storage: [String: Data] = [:]

    public init() {}

    public func set<T: StorableItem>(_ value: T, forKey key: String) throws {
        storage[key] = try value.toData()
    }

    public func load<T: StorableItem>(key: String) throws -> T? {
        guard let data = storage[key] else { return nil }
        return try T.fromData(data)
    }

    public func remove(key: String) throws {
        storage.removeValue(forKey: key)
    }
}
