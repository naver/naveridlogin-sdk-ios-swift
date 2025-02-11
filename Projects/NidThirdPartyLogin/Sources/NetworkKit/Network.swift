//
//  Network.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

public protocol Network {
    func send<T: Request>(_ request: T, completion: @escaping (Result<Output<T.Response>, NetworkError>) -> Void)
}

public final class DefaultNetwork: Network {
    private let session: URLSessionProtocol

    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    public func send<T: Request>(_ request: T, completion: @escaping (Result<Output<T.Response>, NetworkError>) -> Void) {
        var urlRequest: URLRequest!
        do {
            urlRequest = try RequestFactory(request: request).urlRequestRepresentation()
        } catch {
            completion(.failure(error))
        }

        session.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completion(.failure(.urlSessionInternalError(error: error)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let decodedData = try? JSONDecoder().decode(T.Response.self, from: data) else {
                completion(.failure(.decodingFailed(data: data, to: T.Response.self)))
                return
            }

            let output = Output(
                response: decodedData,
                statusCode: (
                    response as? HTTPURLResponse
                )?.statusCode ?? 0
            )
            completion(.success(output))
        }.resume()
    }
}
