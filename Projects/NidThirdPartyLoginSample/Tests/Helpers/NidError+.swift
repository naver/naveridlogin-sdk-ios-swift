//
//  NidError+.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//
import NidCore

extension NidError: @retroactive Equatable {
    public static func == (lhs: NidCore.NidError, rhs: NidCore.NidError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
