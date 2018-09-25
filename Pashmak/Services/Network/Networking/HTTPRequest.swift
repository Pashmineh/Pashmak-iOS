//
//  HTTPRequest.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

import Log

struct HTTPRequest {

  let httpMethod: HTTPMethod
  let requestURL: RequestURL
  let timeout: HTTPTimeOut
  // Will be ommitted if request is not GET or DELETE
  let parameters: JSONDictionary?
  let bodyMessage: ServerModel?
  let headers: [String: String]?
  let accept: HttpContentType
  let contentType: HttpContentType

  init(method: HTTPMethod, url: RequestURL, parameters: JSONDictionary? = nil, bodyMessage: ServerModel? = nil, headers: [String: String]? = nil, timeOut: HTTPTimeOut = .normal, acceptType: HttpContentType = .json, contentType: HttpContentType = .json) {

    self.httpMethod = method
    self.requestURL = url
    self.timeout = timeOut
    self.parameters = parameters
    self.headers = headers
    self.accept = acceptType
    self.contentType = contentType
    self.bodyMessage = bodyMessage

  }

  var request: NSURLRequest? {

    guard let url = self.requestURL.url else {
      return nil
    }

    let result = NSMutableURLRequest(url: url as URL, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: self.timeout.rawValue)

    result.prepareRequestMethod(method: self.httpMethod)
    if let headers = self.headers {
      result.prepareHeaders(headers: headers)
    }
    result.prepareAcceptHeader(accept: self.accept)
    result.prepareContentTypeHeader(contentType: self.contentType)

    if self.httpMethod == HTTPMethod.GET /*|| self.httpMethod == HTTPMethod.DELETE*/ {
      if let params = self.parameters {
        result.prepareURLParameters(params: params, url: url)
      }
    } else {
      if let params = self.parameters {
        if self.contentType == .urlEncodedForm {
          result.prepareURLEndodedForm(params: params)
        } else {
          result.prepareURLParameters(params: params, url: url)
        }
      }
      if let bodyMessage = self.bodyMessage {
        result.prepareBody(bodyMessage: bodyMessage)
      }
    }

    return result
  }

}

extension NSMutableURLRequest {

  private func percentEscapeString(_ string: String) -> String {
    var characterSet = CharacterSet.alphanumerics
    characterSet.insert(charactersIn: "-._* ")

    return string
      .addingPercentEncoding(withAllowedCharacters: characterSet)?
      .replacingOccurrences(of: " ", with: "+")
      .replacingOccurrences(of: " ", with: "+", options: [], range: nil) ?? string
  }

  func prepareRequestMethod(method: HTTPMethod) {
    self.httpMethod = method.rawValue
  }

  func prepareHeaders(headers: [String: String]) {
    for key in headers.keys {
      self.setValue(headers[key], forHTTPHeaderField: key)
    }
  }

  func prepareAcceptHeader(accept: HttpContentType) {
    self.setValue(accept.value, forHTTPHeaderField: HTTPHeaders.Accept)
  }

  func prepareContentTypeHeader(contentType: HttpContentType) {
    self.setValue(contentType.value, forHTTPHeaderField: HTTPHeaders.ContentType)
  }

  func prepareURLEndodedForm(params: JSONDictionary) {
    let parameterArray = params.map { arg -> String in
      let (key, value) = arg
      let val = "\(value)"
      return "\(key)=\(self.percentEscapeString(val))"
    }
    self.httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)

  }

  func prepareURLParameters(params: JSONDictionary, url: NSURL) {
    var qString = ""
    for key in params.keys {

      guard let val = params[key] as? String else {
        Log.trace("Skipping value for key: \(key)")
        continue
      }

      qString += qString.isEmpty ? "" : "&"
      qString += key + "=" + val

    }

    if let encodedQuery = qString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
      qString = encodedQuery
    }

    let newUrlStr = (url.absoluteString ?? "") + "?" + qString
    guard let newURL = NSURL(string: newUrlStr) else {
      Log.error("Invalid url: \(newUrlStr)")
      return
    }

    self.url = newURL as URL
  }

  func prepareBody(bodyMessage: ServerModel) {
    guard let bodyData = bodyMessage.serializedData else {
      Log.trace("Body message is empty. Skipping body value set.")
      return
    }
    //    Log.trace("Request Body is: \(String(data: bodyData, encoding: .utf8) ?? "")") // Debug helper
    self.httpBody = bodyData
    self.setValue("\(bodyData.count)", forHTTPHeaderField: HTTPHeaders.ContentLength)

  }

}
