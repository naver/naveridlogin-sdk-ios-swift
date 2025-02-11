//
//  KeychainServiceTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Testing
@testable import NidLogin
import NidCore
import Foundation

extension Data: @retroactive StorableItem {
    public static func fromData(_ data: Data) throws -> Data {
        return data
    }

    public func toData() throws -> Data {
        return self
    }
}

@Suite(.serialized)
final class KeychainServiceTest {
    let commonKey = "KeychainServiceTestKey"
    let keychainStorage = KeychainStorage(serviceName: "nidthirdpartylogin.keychainstorage")
    let keychainStorableData = "mockStorableData".data(using: .utf8)!

    init() throws {
        try keychainStorage.remove(key: commonKey)
    }

    deinit {
        try? keychainStorage.remove(key: commonKey)
    }

    // MARK: - Load
    @Test
    func keyIsEmpty() {
        let output: Data? = try? keychainStorage.load(key: commonKey)
        #expect(output == nil)
    }

    // MARK: - Set
    @Test("key로 저장된 데이터가 없는지 확인 후, add를 실행")
    func setSuccess() throws {
        let output: Data? = try? keychainStorage.load(key: commonKey)
        try #require(output == nil)

        #expect(throws: Never.self) {
            try keychainStorage.set(keychainStorableData, forKey: commonKey)
        }
    }

    @Test("set 후 잘 저장되었는지 확인")
    func addValidation() throws {
        try keychainStorage.remove(key: commonKey)
        try keychainStorage.set(keychainStorableData, forKey: commonKey)
        #expect(throws: Never.self) {
            let output: Data? = try keychainStorage.load(key: commonKey)
            #expect(output == self.keychainStorableData)
        }
    }

    @Test("이미 동일한 키에 데이터가 있는 경우, 업데이트가 잘 되는지 확인")
    func checkIfSetUpdatesData() throws {
        let prevData = "prevData".data(using: .utf8)!
        let nextData = "nextData".data(using: .utf8)!

        let result: Data? = try? keychainStorage.load(key: commonKey)
        if result != nil {
            try keychainStorage.remove(key: commonKey)
        }
        try keychainStorage.set(prevData, forKey: commonKey)

        #expect(throws: Never.self) {
            try keychainStorage.set(nextData, forKey: commonKey)
            let output: Data? = try? keychainStorage.load(key: commonKey)
            #expect(output != nil && output == nextData)
        }
    }

    // MARK: - Deletion
    @Test
    func tryDeletionWithEmptyData() throws {
        let unregisteredKey = "unRegisteredKey"
        let output: Data? = try? keychainStorage.load(key: unregisteredKey)
        try #require(output == nil)
        #expect(throws: Never.self) {
            try keychainStorage.remove(key: unregisteredKey)
        }
    }

    @Test("데이터 삭제 후, 실제로 데이터가 키체인으로부터 삭제되었는지 확인")
    func validateDeletion() throws {
        let unregisteredKey = "unRegisteredKey"
        let input = "abcdefg".data(using: .utf8)!
        try keychainStorage.set(input, forKey: unregisteredKey)
        #expect(throws: Never.self) {
            try keychainStorage.remove(key: unregisteredKey)
        }
        
        let data: Data? = try keychainStorage.load(key: unregisteredKey)
        #expect(data == nil)
    }
}


