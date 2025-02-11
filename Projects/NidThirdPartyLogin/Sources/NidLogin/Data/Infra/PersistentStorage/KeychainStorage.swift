//
//  KeychainStorage.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import Security

public final class KeychainStorage: PersistentStorage {
    // MARK: - Properties
    private let baseOptions: KeychainOptions

    // MARK: - Initializer
    public init(serviceName: String) {
        self.baseOptions = .defaultOptions(serviceName: serviceName)
    }

    // MARK: - Set
    /// 데이터가 이미 존재하면 업데이트하고, 없으면 추가
    ///
    public func set<T: StorableItem>(_ value: T, forKey key: String) throws {
        let data = try value.toData()

        let query = baseOptions
            .extending(.account, value: key)

        let attributes = KeychainOptions()
            .extending(.account, value: key)
            .extending(.valueData, value: data)

        let status = SecItemUpdate(query.builtQuery, attributes.builtQuery)

        guard status != errSecItemNotFound else {
            try add(value, forKey: key)
            return
        }

        guard status == errSecSuccess else {
            throw KeyChainError.undefined(status: status)
        }
    }

    /// 신규 데이터 추가에 사용. 이미 존재하는 데이터가 있으면 에러 발생.
    private func add<T: StorableItem>(_ value: T, forKey key: String) throws {
        let data = try value.toData()

        let query = baseOptions
            .extending(.account, value: key)
            .extending(.valueData, value: data)

        let status = SecItemAdd(query.builtQuery, nil)

        guard status != errSecDuplicateItem else {
            throw KeyChainError.duplicateItem
        }

        guard status == errSecSuccess else {
            throw KeyChainError.undefined(status: status)
        }
    }

    // MARK: - Load
    public func load<T: StorableItem>(key: String) throws -> T? {
        let query = baseOptions
            .extending(.account, value: key)
            .extending(key: kSecReturnAttributes, value: true)
            .extending(key: kSecReturnData, value: true)

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query.builtQuery, &item)

        guard status != errSecItemNotFound else {
            return nil
        }

        guard status == errSecSuccess else {
            throw KeyChainError.undefined(status: status)
        }

        guard let existingItem = item as? [String: Any],
              let data = existingItem[kSecValueData as String] as? Data
        else {
            throw KeyChainError.decodingFailed
        }

        return try T.fromData(data)
    }

    // MARK: - Remove
    public func remove(key: String) throws {
        let query = baseOptions
            .extending(.account, value: key)

        let status = SecItemDelete(query.builtQuery)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeyChainError.undefined(status: status)
        }
    }
}

extension KeychainStorage {
    enum KeyChainError: Equatable, Error, LocalizedError, CustomStringConvertible {
        case duplicateItem
        case decodingFailed
        case undefined(status: OSStatus)

        var description: String {
            return errorDescription ?? "Undefined"
        }

        var errorDescription: String? {
            switch self {
            case .duplicateItem: return "Keychain error: Duplicate item registered"
            case .decodingFailed: return "Keychain error: Decoding failed"
            case .undefined(let status): return "Keychain error: \(status)"
            }
        }
    }

    struct KeychainOptions {
        enum Option {
            case account
            case valueData

            var key: CFString {
                switch self {
                case .account: return kSecAttrAccount
                case .valueData: return kSecValueData
                }
            }
        }

        private let value: [String: Any]

        init(value: [String: Any]? = nil) {
            self.value = value ?? [:]
        }

        func extending(_ option: Option, value: Any) -> KeychainOptions {
            self.extending(key: option.key, value: value)
        }

        func extending(key: CFString, value: Any) -> KeychainOptions {
            var newValue = self.value
            newValue[key as String] = value
            return KeychainOptions(value: newValue)
        }

        static func defaultOptions(serviceName: String) -> KeychainOptions {
            var query = [String: Any]()
            query[kSecClass as String] = kSecClassGenericPassword
            query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            query[kSecAttrService as String] = serviceName
            return KeychainOptions(value: query)
        }

        var builtQuery: CFDictionary {
            return value as CFDictionary
        }
    }
}
