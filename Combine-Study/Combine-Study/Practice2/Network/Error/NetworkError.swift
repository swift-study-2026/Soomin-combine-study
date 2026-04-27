//
//  NetworkError.swift
//  Combine-Study
//
//  Created by mandoo on 4/27/26.
//

enum NetworkError: Int, Error, CustomStringConvertible {
    var description: String { self.errorDescription }
    case requestEncodingError
    case responseDecodingError
    case responseError
    case unknownError
    case serverError = 500
    case notFoundError = 404
    
    var errorDescription: String {
        switch self {
        case .requestEncodingError: return "REQUEST_ENCODING_ERROR"
        case .responseError: return "RESPONSE_ERROR"
        case .responseDecodingError: return "RESPONSE_DECODING_ERROR"
        case .unknownError: return "UNKNOWN_ERROR"
        case .serverError: return "500:INTERNAL_SERVER_ERROR"
        case .notFoundError: return "404:NOT_FOUND_ERROR"
        }
    }
}
