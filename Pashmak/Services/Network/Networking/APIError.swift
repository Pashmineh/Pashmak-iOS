//
//  APIError.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

enum APIError: Error, LocalizedError {
  case invalidRequest
  case networkError(Error)
  case invalidResponse
  case invalidResponseCode(Int)
  case noResponseData
  case parserFailed(Error)
  case invalidFile
  case invalidUploadFile
  case invalidParameters(String)
  case accountDeactivated(String)
  case operationError(String)
  case noConnection
  case invalidPrecondition(String)

  public var errorDescription: String? {
    switch self {
    case .invalidRequest: return "Could not make URLRequest from HTTPRequest."
    case .networkError(let err): return "There was a network Error:\n\(err)"
    case .invalidResponse: return "Could not convert url response."
    case .invalidResponseCode(let status): return "Response status code is invalid [\(status)]:\n)"
    case .noResponseData: return "Server response has no data."
    case .parserFailed(let error): return "Could not parse server's response. \n\(error.localizedDescription)"
    case .invalidFile: return "Could not convert file for upload."
    case .invalidUploadFile: return "Document has no file to upload."
    case .invalidParameters(let parameter): return "Parameter missing: \(parameter)"
    case .accountDeactivated(let message): return "Account has been daectivated with message: \(message)"
    case .operationError(let error): return "Error in operation.\n\(error)"
    case .noConnection: return "ارتباط خود با اینترنت را بررسی کنید."
    case .invalidPrecondition(let message): return message
    }
  }
}
