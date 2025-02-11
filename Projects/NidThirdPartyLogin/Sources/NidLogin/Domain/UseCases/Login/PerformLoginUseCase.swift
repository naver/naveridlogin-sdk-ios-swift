//
//  PerformLoginUseCase.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import NidCore
protocol PerformLoginUseCase {
    associatedtype ProcessType
    func createAndExecuteProcess(
        requestValue: LoginRequestValue,
        callback: @escaping (Result<LoginResult, NidError>) -> Void
    ) -> LoginProcess
}
