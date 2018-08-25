//
//  ServerRequestBase.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

struct ServerRequest {
  
}

/*
 
 static func registerDevice(with phoneNumber: String) -> HTTPRequest {
 
 var url = RequestURL()
 url.appendPathComponents([.usermanagement, .api,.users(nil)])
 
 let headers: [String: String] =  [HTTPHeaders.Authorization: HTTPHeaderValues.basicAuthorizatoion].merging(BaseRequestHeaders) { (current, _) in current }
 let deviceModel = ServerModels.UserDevice(deviceID: DeviceInfo.DeviceID)
 let userCreateModel = ServerModels.UserCreate()
 userCreateModel.dev = deviceModel
 userCreateModel.username = phoneNumber
 return HTTPRequest(method: .POST, url: url, parameters: nil, bodyMessage: userCreateModel, headers: headers)
 }
 
 }
 */
