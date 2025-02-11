//
//  DefaultOpenAPIRepository.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NetworkKit
import NidCore

final class DefaultOpenAPIRepository: UserProfileRepository, AccessTokenVerificationRepository {
    private let network: Network
    private let systemInfo: SystemInfo
    init(network: Network, systemInfo: SystemInfo) {
        self.network = network
        self.systemInfo = systemInfo
    }

    func fetchUserProfile(accessToken: String, callback: @escaping (Result<[String: String], NidError>) -> Void) {
        let request = FetchUserProfileRequest(accessToken: accessToken)
        network.send(request, completion: { [weak self] result in
            self?.handleNetworkResponse(result: result, transform: { $0.toDomain() }, callback: callback)
        })
    }

    func verify(_ accessToken: String, callback: @escaping (Result<Bool, NidError>) -> Void) {
        let request = ValidateAccessTokenRequest(accessToken: accessToken, userAgent: systemInfo.userAgent())
        network.send(request) { [weak self] result in
            self?.handleNetworkResponse(result: result, transform: { $0.toDomain() }, callback: callback)
        }
    }
}

extension DefaultOpenAPIRepository {
    private func handleNetworkResponse<R: ResultCodeResponse, D>(
        result: Result<Output<R>, NetworkError>,
        transform: (R) -> D?,
        callback: @escaping (Result<D, NidError>) -> Void
    ) {
        switch result {
        case .success(let output):
            guard let domain = transform(output.response) else {
                callback(.failure(
                    .serverError(
                        .authError(
                            errorCode: output.response.resultCode,
                            errorDescription: output.response.message
                        )
                    )
                ))
                return
            }
            callback(.success(domain))
        case .failure(let error):
            callback(.failure(.serverError(.networkError(error))))
        }
    }
}
