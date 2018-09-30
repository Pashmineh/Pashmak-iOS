//
//  UserAccountModel.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/30/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

/*
{
  "id": 1052,
  "login": "09122214063",
  "firstName": "محمد",
  "lastName": "پروشانی",
  "email": "porooshani@gmail.com",
  "imageUrl": null,
  "activated": true,
  "langKey": null,
  "createdBy": "anonymousUser",
  "platform": null,
  "createdDate": "2018-08-26T08:31:52.260Z",
  "lastModifiedBy": "09122214063",
  "lastModifiedDate": "2018-09-30T10:49:55.142Z",
  "authorities": [
  "ROLE_USER",
  "ROLE_ADMIN"
  ]
}
*/

extension ServerModels {

  class UserAccount: ServerModel {
    var id: UInt64 = 0
    var login: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var imageUrl: String?
  }

}
