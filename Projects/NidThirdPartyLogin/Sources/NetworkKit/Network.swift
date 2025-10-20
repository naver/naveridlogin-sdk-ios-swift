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
        let mainThreadCompletion: (Result<Output<T.Response>, NetworkError>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        var urlRequest: URLRequest!
        do {
            urlRequest = try RequestFactory(request: request).urlRequestRepresentation()
        } catch {
            return mainThreadCompletion(.failure(error))
        }

        session.dataTask(with: urlRequest) { data, response, error in
            if let error {
                return mainThreadCompletion(.failure(.urlSessionInternalError(error: error)))
            }

            guard let data = data else {
                return mainThreadCompletion(.failure(.invalidResponse))
            }

            guard let decodedData = try? JSONDecoder().decode(T.Response.self, from: data) else {
                return mainThreadCompletion(.failure(.decodingFailed(data: data, to: T.Response.self)))
            }

            let output = Output(
                response: decodedData,
                statusCode: (
                    response as? HTTPURLResponse
                )?.statusCode ?? 0
            )
            mainThreadCompletion(.success(output))
        }.resume()
    }
}
