//
//  KeychainStorable.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
public protocol StorableItem: Codable {
    static func fromData(_ data: Data) throws -> Self
    func toData() throws -> Data
}

extension Bool: StorableItem {
    public static func fromData(_ data: Data) throws -> Bool {
        return try JSONDecoder().decode(Bool.self, from: data)
    }

    public func toData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}
