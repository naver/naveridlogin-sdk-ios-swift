//
//  RequestFactory.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//
import Foundation

struct RequestFactory<T: Request> {
    private let request: T

    init(request: T) {
        self.request = request
    }

    func urlRequestRepresentation() throws(NetworkError) -> URLRequest {
        var urlRequest: URLRequest!
        switch request.method {
        case .get: urlRequest = try createGetUrlRequest(self.request)
        case .post: urlRequest = try createPostUrlRequest(self.request)
        }

        return urlRequest
    }

    private func createGetUrlRequest(_ request: T) throws(NetworkError) -> URLRequest {
        guard var components = URLComponents(
            url: request.baseUrl.appendingPathComponent(request.path),
            resolvingAgainstBaseURL: true) else {
            throw NetworkError.invalidUrlOrPath(url: request.baseUrl, path: request.path)
        }

        components.queryItems = request
            .parameters
            .map { URLQueryItem(name: $0.key, value: "\($0.value)") }

        guard let url = components.url else {
            throw NetworkError.invalidQueryParams(queryParams: request.parameters)
        }

        return urlRequest(request, url: url)
    }

    private func createPostUrlRequest(_ request: T) throws(NetworkError) -> URLRequest {
        let url: URL!

        if #available(iOS 16.0, *) {
            url = request.baseUrl.appending(path: request.path)
        } else {
            url = request.baseUrl.appendingPathComponent(request.path)
        }

        var urlRequest = urlRequest(request, url: url)

        guard let httpBody = httpBody(for: request) else {
            throw NetworkError.invalidHTTPBodyParams(bodyParams: request.parameters)
        }

        urlRequest.httpBody = httpBody

        return urlRequest
    }

    private func urlRequest(_ request: T, url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.headers = request.header
        urlRequest.httpMethod = request.method.rawValue
        return urlRequest
    }

    private func httpBody(for request: T) -> Data? {
        let data: Data?

        if request.header.contains(.contentType(.formUrlEncoded)) {
            data = request.formURLEncodedHTTPBody()
        } else {
            data = request.httpBody()
        }

        return data
    }
}
