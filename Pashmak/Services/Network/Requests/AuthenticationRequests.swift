//
//  AuthenticationRequests.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/26/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

extension ServerRequest {

  enum Authentication {

    static func authenticate(userName: String, password: String, info: ServerModels.Authentication.Request) -> HTTPRequest {
      var url = RequestURL()
      url.appendPathComponents([.login])
      let userPass = "\(userName):\(password)"
      guard let userPassData = userPass.data(using: .utf8) else {
        fatalError("Could not make user pass data!")
      }
      let base64UserPass = "Basic " + userPassData.base64EncodedString()
      let headers = [HTTPHeaders.Authorization: base64UserPass]
      return HTTPRequest(method: .POST, url: url, parameters: nil, bodyMessage: info, headers: headers, timeOut: .normal, acceptType: .json, contentType: .json)

    }

    static func updateToken(updateInfo: ServerModels.TokenUpdateRequest) -> HTTPRequest {
      var url = RequestURL()
      url.appendPathComponents([.updatePush])
      let headers: [String: String] =  [HTTPHeaders.Authorization: HTTPHeaderValues.OauthToken].merging(baseRequestHeaders) { current, _ in current }
      return HTTPRequest(method: .PUT, url: url, parameters: nil, bodyMessage: updateInfo, headers: headers, timeOut: .normal, acceptType: .json, contentType: .json)
    }

  }

}
