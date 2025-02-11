//
//  DefaultTokenRepository.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//
import Foundation
import NidCore

extension AccessToken: StorableItem {
    public static func fromData(_ data: Data) throws -> NidCore.AccessToken {
        return try JSONDecoder().decode(AccessToken.self, from: data)
    }

    public func toData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

extension RefreshToken: StorableItem {
    public static func fromData(_ data: Data) throws -> NidCore.RefreshToken {
        return try JSONDecoder().decode(RefreshToken.self, from: data)
    }

    public func toData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

final class DefaultTokenRepository: TokenRepository {
    private enum Constant {
        static func accessTokenKey(for key: String) -> String {
            return key + ".nidAccessTokenKey"
        }

        static func refreshTokenKey(for key: String) -> String {
            return key + ".nidRefreshTokenKey"
        }
    }

    private let dataSource: PersistentStorage
    private var isFirstLaunch: Bool = true

    init(dataSource: PersistentStorage) {
        self.dataSource = dataSource
    }

    // dataSource 접근하기 전에 항상 호출되어야함. 첫 앱 실행시 AT와 RT를 삭제하는 기능 포함.
    private func validatePreconditions(key: String) {
        guard self.isFirstLaunch == true else { return }
        do {
            try dataSource.remove(key: Constant.accessTokenKey(for: key))
            try dataSource.remove(key: Constant.refreshTokenKey(for: key))
        } catch {
            NidLogger.log("Failed to remove tokens", level: .info)
        }
        isFirstLaunch = false
    }

    func accessToken(for key: String) -> NidCore.AccessToken? {
        validatePreconditions(key: key)

        do {
            let accessToken: AccessToken? = try dataSource.load(key: Constant.accessTokenKey(for: key))
            return accessToken
        } catch {
            NidLogger.log(error, level: .error)
            return nil
        }
    }

    func refreshToken(for key: String) -> NidCore.RefreshToken? {
        validatePreconditions(key: key)

        do {
            let refreshToken: RefreshToken? = try dataSource.load(key: Constant.refreshTokenKey(for: key))
            return refreshToken
        } catch {
            NidLogger.log(error, level: .error)
            return nil
        }
    }

    func updateAccessToken(forKey key: String, _ accessToken: NidCore.AccessToken) {
        validatePreconditions(key: key)

        do {
            try dataSource.set(accessToken, forKey: Constant.accessTokenKey(for: key))
        } catch {
            NidLogger.log(error, level: .error)
        }
    }

    func updateRefreshToken(forKey key: String, _ refreshToken: NidCore.RefreshToken) {
        validatePreconditions(key: key)

        do {
            try dataSource.set(refreshToken, forKey: Constant.refreshTokenKey(for: key))
        } catch {
            NidLogger.log(error, level: .error)
        }
    }

    func removeToken(forKey key: String) {
        validatePreconditions(key: key)

        do {
            try dataSource.remove(key: Constant.accessTokenKey(for: key))
            try dataSource.remove(key: Constant.refreshTokenKey(for: key))
        } catch {
            NidLogger.log(error, level: .error)
        }
    }
}

extension DefaultTokenRepository: FirstLaunchListener {
    func setIsFirstLaunch(to value: Bool) {
        self.isFirstLaunch = value
    }
}
