//
//  HomeRequests.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/27/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

extension ServerRequest {

  enum Home {

    static func fetchHome() -> HTTPRequest {
      var url = RequestURL()
      url.appendPathComponents([.api, .home])
      let headers: [String: String] =  [HTTPHeaders.Authorization: HTTPHeaderValues.OauthToken].merging(baseRequestHeaders) { current, _ in current }

      return HTTPRequest(method: .GET, url: url, parameters: nil, bodyMessage: nil, headers: headers, timeOut: .normal, acceptType: .json, contentType: .json)

    }

  }

}
