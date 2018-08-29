//
//  CheckinRequests.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/28/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

extension ServerRequest {

  struct Checkin {

    static func checkin(info: ServerModels.Checkin.Request) -> HTTPRequest {
      var url = RequestURL()
      url.appendPathComponents([.api, .checkin])

      let params: [String: String] = ["checkinType": info.type.rawValue]
      let headers: [String: String] =  [HTTPHeaders.Authorization: HTTPHeaderValues.OauthToken].merging(baseRequestHeaders) { (current, _) in current }

      return HTTPRequest(method: .POST, url: url, parameters: params, bodyMessage: info, headers: headers, timeOut: .short, acceptType: .json, contentType: .json)
    }
  }

}
