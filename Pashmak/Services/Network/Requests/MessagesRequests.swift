//
//  MessagesRequests.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/16/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

extension ServerRequest {

  enum Messages {

    static func getMessages() -> HTTPRequest {
      var url = RequestURL()
      url.appendPathComponents([.api, .messages])
      let params: [String: String] = ["sort": "sendTime,desc"]
      let headers: [String: String] =  [HTTPHeaders.Authorization: HTTPHeaderValues.OauthToken].merging(baseRequestHeaders) { current, _ in current }
      return HTTPRequest(method: .GET, url: url, parameters: params, bodyMessage: nil, headers: headers, timeOut: .normal, acceptType: .json, contentType: .json)

    }

  }

}
