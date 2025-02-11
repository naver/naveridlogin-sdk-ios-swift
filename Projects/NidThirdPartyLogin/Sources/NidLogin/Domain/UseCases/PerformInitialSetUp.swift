//
//  PerformInitialSetUp.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NidCore

public protocol FirstLaunchListener {
    func setIsFirstLaunch(to: Bool)
}

public protocol UserStateRepository {
    func isFirstLaunch() -> Bool
    func setIsNotFirstLaunch()
}

public final class PerformInitialSetUp {
    private let listeners: [FirstLaunchListener]
    private let userStateRepository: UserStateRepository

    public init(listeners: [FirstLaunchListener], userStateRepository: UserStateRepository) {
        self.listeners = listeners
        self.userStateRepository = userStateRepository
    }

    // userStateRepo를 통해서 앱 설치 후 first launch인지 확인하고, notify를 수행한다.
    // 이후 first launch가 아닌 상태로 업데이트한다.
    public func prepare() {
        let isFirstLaunch = userStateRepository.isFirstLaunch()

        listeners
            .forEach { listener in
                listener.setIsFirstLaunch(to: isFirstLaunch)
            }

        if isFirstLaunch {
            userStateRepository.setIsNotFirstLaunch()
        }
    }
}
