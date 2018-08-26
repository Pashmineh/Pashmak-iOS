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
      url.appendPathComponents([.api,.authenticate])
      return HTTPRequest(method: .POST, url: url, parameters: nil, bodyMessage: info, headers: nil, timeOut: .Normal, acceptType: .json, contentType: .json)
      
    }
    
  }
  
}
