//
//  NetworkError.swift
//  
//
//  Created by Noel Conde Algarra on 12/6/22.
//

import Foundation

public enum NetworkError:Error {
    case general(Error)
    case statusCode(Int)
    case noHTTP
    case notExpectedData
    case unexpected
    
    var description:String {
        switch self {
        case .general(let error):
            return "General error: \(error)"
        case .statusCode(let status):
            return "Status error: \(status)"
        case .noHTTP:
            return "Not a valid HTTP request"
        case .notExpectedData:
            return "Not the expected data"
        case .unexpected:
            return "unexpected"
        }
    }
}
