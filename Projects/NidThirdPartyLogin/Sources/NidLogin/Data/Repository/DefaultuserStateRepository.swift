//
//  DefaultuserStateRepository.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import NidCore

final class DefaultuserStateRepository: UserStateRepository {
    private let userDefaultsStorage: PersistentStorage
    private let isIntalledBeforeKey = "isInstalledBeforeFlag"

    init(persistentStorage: PersistentStorage) {
        self.userDefaultsStorage = persistentStorage
    }

    func isFirstLaunch() -> Bool {
        let flag: Bool? = try? userDefaultsStorage.load(key: isIntalledBeforeKey)
        if flag != nil {
            return false
        }
        return true
    }

    func setIsNotFirstLaunch() {
        do {
            try userDefaultsStorage.set(true, forKey: isIntalledBeforeKey)
        } catch {
            NidLogger.log("UserDefaults Update Failed", level: .info)
        }
    }
}
