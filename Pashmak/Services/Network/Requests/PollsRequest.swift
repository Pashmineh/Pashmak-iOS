//
//  PollsRequest.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/17/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

extension ServerRequest {
  enum Polls {
    static func getPolls() -> HTTPRequest {
      var url = RequestURL()
      url.appendPathComponents([.api, .polls])
      let headers: [String: String] =  [HTTPHeaders.Authorization: HTTPHeaderValues.OauthToken].merging(baseRequestHeaders) { current, _ in current }
      return HTTPRequest(method: .GET, url: url, parameters: nil, bodyMessage: nil, headers: headers, timeOut: .normal, acceptType: .json, contentType: .json)
    }

    static func vote(_ item: ServerModels.Poll.Vote, isUnvote: Bool) -> HTTPRequest {
      var url = RequestURL()
      url.appendPathComponents([.api, .polls, .vote])
      let headers: [String: String] =  [HTTPHeaders.Authorization: HTTPHeaderValues.OauthToken].merging(baseRequestHeaders) { current, _ in current }
      let method: HTTPMethod = isUnvote ? .DELETE : .POST
      return HTTPRequest(method: method, url: url, parameters: nil, bodyMessage: item, headers: headers, timeOut: .normal, acceptType: .json, contentType: .json)
    }
  }
}
