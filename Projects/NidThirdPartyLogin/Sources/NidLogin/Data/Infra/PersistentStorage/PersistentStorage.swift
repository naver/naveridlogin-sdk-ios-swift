//
//  PersistentStorage.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

public protocol PersistentStorage {
    func set<T: StorableItem>(_ value: T, forKey key: String) throws
    func load<T: StorableItem>(key: String) throws -> T?
    func remove(key: String) throws
}
