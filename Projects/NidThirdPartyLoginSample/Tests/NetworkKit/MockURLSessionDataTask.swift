//
//  MockURLSessionDataTask.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NetworkKit

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}

    override func resume() {
        self.resumeDidCall()
    }
}

protocol MockResponseProtocol {
    var data: Data { get set }
}

final class MockURLSession<R: MockResponseProtocol>: URLSessionProtocol {
    private var sessionDataTask: MockURLSessionDataTask?
    var response: R
    var networkResult: NetworkResult = .shouldReturnSuccesStatusCode

    enum NetworkResult {
        case shouldReturnSuccesStatusCode
        case shouldReturn404FailureStatusCode
        case shouldReturn500FailureStatusCode
    }

    init(response: R) {
        self.response = response
    }

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void
    ) -> URLSessionDataTask {
        let sessionDataTask: MockURLSessionDataTask
        switch networkResult {
        case .shouldReturnSuccesStatusCode:
            sessionDataTask = successDataTask(with: request, completionHandler: completionHandler)
        case .shouldReturn404FailureStatusCode:
            sessionDataTask = failureDataTask(with: request, statusCode: 400, completionHandler: completionHandler)
        case .shouldReturn500FailureStatusCode:
            sessionDataTask = failureDataTask(with: request, statusCode: 500, completionHandler: completionHandler)
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }

    private func successDataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void
    ) -> MockURLSessionDataTask {

        let dataTask = MockURLSessionDataTask()
        let sucessResponse = HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: "2",
            headerFields: nil
        )

        dataTask.resumeDidCall = {
            completionHandler(self.response.data, sucessResponse, nil)
        }

        return dataTask
    }

    private func failureDataTask(
        with request: URLRequest,
        statusCode: Int,
        completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void
    ) -> MockURLSessionDataTask {

        let dataTask = MockURLSessionDataTask()
        let failureResponse = HTTPURLResponse(
            url: request.url!,
            statusCode: statusCode,
            httpVersion: "2",
            headerFields: nil
        )

        dataTask.resumeDidCall = {
            completionHandler(self.response.data, failureResponse, nil)
        }

        return dataTask
    }
}
