//
//  AuthenticationModels.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/26/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
/*
 {
 "deviceID": "string",
 "password": "string",
 "platform": "string",
 "rememberMe": true,
 "token": "string",
 "username": "string"
 }
 */
/*
{
  "avatar": "string",
  "lastName": "string",
  "name": "string",
  "token": "string"
}
 */
extension ServerModels {
  enum Authentication {
    class Request: ServerModel {

      let deviceID: String
      let password: String
      let platform: String
      let rememberMe: Bool = true
      let token: String
      let username: String

      init(username: String, password: String) {

        self.username = username
        self.password = password

        self.deviceID = Settings.current.deviceToken
        self.platform = "IOS"
        self.token = Settings.current.pushToken

      }

    }

    class Response: ServerModel {
      var avatar: String?
      var lastName: String?
      var name: String?
      var token: String?

    }

  }
}
