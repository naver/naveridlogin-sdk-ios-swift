//
//  DefaultLoginResultRepository.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NetworkKit
import NidCore

final class DefaultLoginResultRepository: LoginResultRepository {
    private let network: Network
    private let systemInfo: SystemInfo

    init(network: Network, systemInfo: SystemInfo) {
        self.network = network
        self.systemInfo = systemInfo
    }

    func requestAccessToken(
        clientId: String,
        clientSecret: String,
        authCode: String,
        callback: @escaping (Result<LoginResult, NidError>) -> Void
    ) {
        let request = IssueAccessTokenRequest(
            clientId: clientId,
            clientSecret: clientSecret,
            authCode: authCode,
            userAgent: systemInfo.userAgent()
        )

        network.send(request, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let output):
                do {
                    let successResponse = try self.toSuccessResponse(response: output.response)
                    callback(.success(successResponse.toDomain()))
                } catch let error as NidError {
                       callback(.failure(error))
                } catch {
                    callback(.failure(.serverError(.networkError(error))))
                }
            case .failure(let error):
                callback(.failure(.serverError(.networkError(error))))
            }
        })
    }

    func updateAccessToken(
        clientId: String,
        clientSecret: String,
        refreshToken: RefreshToken,
        callback: @escaping (Result<LoginResult, NidError>) -> Void
    ) {
        let request = UpdateAccessTokenRequest(
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken.tokenString,
            userAgent: systemInfo.userAgent()
        )

        network.send(request, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let output):
                do {
                    let successResponse = try self.toSuccessResponse(response: output.response)
                    callback(.success(successResponse.toDomain(refreshToken: refreshToken)))
                } catch let error as NidError {
                    callback(.failure(error))
                } catch {
                    callback(.failure(.serverError(.networkError(error))))
                }
            case .failure(let error):
                callback(.failure(.serverError(.networkError(error))))
            }
        })
    }

    func revokeOAuthConnection(
        clientId: String,
        clientSecret: String,
        accessToken: String,
        callback: @escaping (Result<String, NidError>) -> Void
    ) {
        let request = DeleteAccessTokenRequest(
            clientId: clientId,
            clientSecret: clientSecret,
            accessToken: accessToken,
            userAgent: systemInfo.userAgent()
        )

        network.send(request, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let output):
                do {
                    let successResponse = try self.toSuccessResponse(response: output.response)
                    callback(.success((successResponse.accessToken)))
                } catch let error as NidError {
                    callback(.failure(error))
                } catch {
                    callback(.failure(.serverError(.networkError(error))))
                }
            case .failure(let error):
                callback(.failure(.serverError(.networkError(error))))
            }
        })
    }
}

extension DefaultLoginResultRepository {
    private func toSuccessResponse<S: ResultResponse>(response: S) throws(NidError) -> S.Success {
        if let failureResponse = response.failureResponse, response.successResponse == nil {
            throw NidError.serverError(.authError(
                errorCode: failureResponse.errorCode,
                errorDescription: failureResponse.description
            ))
        }

        if let successResponse = response.successResponse, response.failureResponse == nil {
            return successResponse
        }

        throw .serverError(.invalidResponseFormat)
    }
}
