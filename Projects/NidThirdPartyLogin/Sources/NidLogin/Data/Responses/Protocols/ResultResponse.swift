//
//  ResultResponse.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

protocol ResultResponse {
    associatedtype Success: SuccessResponse
    associatedtype Failure: FailureResponse
    var successResponse: Success? { get }
    var failureResponse: Failure? { get }
}

protocol SuccessResponse {
}

protocol FailureResponse {
    var errorCode: String { get }
    var description: String? { get }
}
