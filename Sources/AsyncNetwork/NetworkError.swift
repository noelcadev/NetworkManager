//
//  NetworkError.swift
//
//
//  Created by Noel Conde Algarra on 12/6/22.
//

import Foundation

/// Network error cases and its description
public enum NetworkError: Error, LocalizedError {
    case general(Error)
    case invalidStatusCode(Int)
    case invalidRequest
    case invalidData(Error)
    case customError(Any)

    public var errorDescription: String? {
        switch self {
        case let .general(error):
            return "General error: \(error)"
        case let .invalidStatusCode(status):
            return "Status error: \(status)"
        case .invalidRequest:
            return "Not a valid HTTP request"
        case let .invalidData(error):
            return "Not the expected data: \(error)"
        case .customError:
            return "Custom error"
        }
    }
}
