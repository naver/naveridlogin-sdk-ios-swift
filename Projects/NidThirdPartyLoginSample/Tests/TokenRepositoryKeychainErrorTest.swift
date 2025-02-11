//
//  TokenRepositoryKeychainErrorTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Testing
@testable import NidLogin
import Foundation
import NidCore

final class FakeKeychainStorage: PersistentStorage {
    enum State {
        case idle
        case notWorking
    }

    var currentState: State = .idle
    var storage: [String: Any] = [:]

    func set<T>(_ value: T, forKey key: String) throws where T : NidLogin.StorableItem {
        if currentState == .notWorking {
            throw KeychainStorage.KeyChainError.undefined(status: .zero)
        } else {
            self.storage[key] = value
        }
    }

    func load<T>(key: String) throws -> T? where T : NidLogin.StorableItem {
        if currentState == .notWorking {
            throw KeychainStorage.KeyChainError.undefined(status: .zero)
        } else {
            self.storage[key] as? T
        }
    }

    func remove(key: String) throws {
        if currentState == .notWorking {
            throw KeychainStorage.KeyChainError.undefined(status: .zero)
        } else {
            self.storage.removeValue(forKey: key)
        }
    }
}

struct TokenRepositoryKeychainErrorTest {
    let clientIdKey = "clientIdKey"

    @Test("카채인 Storage 이용애 실패할 때 메모리 Storage로 전환이 되는지 확인하고 operation들을 실행한다.")
    func testDefaultStorageWithFailedKeychainStorage() async throws {
        let keychainStorage = FakeKeychainStorage()
        keychainStorage.currentState = .notWorking
        let memoryStorage = MemoryStorage()
        let defaultStorage = DefaultStorage(
            primaryStorage: keychainStorage,
            secondaryStorage: memoryStorage
        )
        let repo = DefaultTokenRepository(
            dataSource: defaultStorage
        )

        let accessToken = AccessToken(expiresIn: 100, tokenString: "fakeAccessTokenString")
        #expect(defaultStorage.currentDataSource == .primary)
        repo.updateAccessToken(forKey: clientIdKey, accessToken)
        #expect(defaultStorage.currentDataSource == .secondary)
        #expect(repo.accessToken(for: clientIdKey)?.tokenString == accessToken.tokenString && repo.accessToken(for: clientIdKey)?.expiresAt == repo.accessToken(for: clientIdKey)?.expiresAt)
        repo.removeToken(forKey: clientIdKey)
        #expect(repo.accessToken(for: clientIdKey) == nil)
        #expect(defaultStorage.currentDataSource == .secondary)
    }

    @Test("카채인 Storage 이용애 실패하는 환경에서 삭제를 시도시 메모리 Storage로 전환이 되는지 확인한다.")
    func deletionTest() async throws {
        let keychainStorage = FakeKeychainStorage()
        keychainStorage.currentState = .notWorking
        let memoryStorage = MemoryStorage()
        let defaultStorage = DefaultStorage(
            primaryStorage: keychainStorage,
            secondaryStorage: memoryStorage
        )
        let repo = DefaultTokenRepository(
            dataSource: defaultStorage
        )
        #expect(defaultStorage.currentDataSource == .primary)
        repo.removeToken(forKey: clientIdKey)
        #expect(defaultStorage.currentDataSource == .secondary)
    }
}
