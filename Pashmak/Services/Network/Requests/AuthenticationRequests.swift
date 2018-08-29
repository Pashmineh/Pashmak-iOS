//
//  AuthenticationRequests.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/26/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

extension ServerRequest {

  struct Authentication {

    static func authenticate(info: ServerModels.Authentication.Request) -> HTTPRequest {
      var url = RequestURL()
      url.appendPathComponents([.api, .authenticate])
      return HTTPRequest(method: .POST, url: url, parameters: nil, bodyMessage: info, headers: nil, timeOut: .normal, acceptType: .json, contentType: .json)

    }

    static func updateToken(token: String) -> HTTPRequest {
      var url = RequestURL()
      url.appendPathComponents([.api, .updatePush])
      let headers: [String: String] =  [HTTPHeaders.Authorization: HTTPHeaderValues.OauthToken].merging(baseRequestHeaders) { (current, _) in current }
      let params = ["token": token]
      return HTTPRequest(method: .PUT, url: url, parameters: params, bodyMessage: nil, headers: headers, timeOut: .normal, acceptType: .json, contentType: .json)
    }

  }

}
