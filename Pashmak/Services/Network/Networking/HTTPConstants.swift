//
//  HTTPConstants.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

enum HTTPMethod: String {

  case GET
  case POST
  case PUT
  case DELETE
  case HEAD
  case OPTIONS
}

enum HTTPTimeOut: Double {

  case short = 15.0
  case normal = 30.0
  case long = 120.0
  case unlimited = 3600.0

}

struct HTTPHeaders {

  static let ContentType = "content-type"
  static let ContentLength = "Content-Length"
  static let Accept = "Accept"
  static let Authorization = "Authorization"
  static let UserAgent = "User-Agent"
  static let AcceptLanguage = "Accept-Language"

}

struct HTTPHeaderValues {
  static let basicAuthorizatoion = "Basic YnJvd3NlcjoxMjM0NTY="
  static let UserAgent = "mobile"
  static let AcceptLanguage = "fa"
}

enum HttpContentType {
  case any
  case json
  case protobuf
  case urlEncodedForm
  case multipartFormdata
  case text

  var value: String {
    switch self {
    case .any:
      return "*/*"
    case .json:
      return "application/json;charset=UTF-8"
    case .protobuf:
      return "application/octet-stream"
    case .urlEncodedForm:
      return "application/x-www-form-urlencoded"
    case .multipartFormdata:
      return "multipart/form-data"
    case .text:
      return "text/plain"
    }
  }
}

var baseRequestHeaders: [String: String] {
  return [HTTPHeaders.UserAgent: HTTPHeaderValues.UserAgent, HTTPHeaders.AcceptLanguage: HTTPHeaderValues.AcceptLanguage]
}
