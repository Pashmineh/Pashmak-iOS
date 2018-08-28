//
//  CheckinModels.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/28/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
import IGListKit

/*
 {
 "checkinTime": "2018-08-28T06:05:19.952Z",
 "id": 0,
 "message": "string",
 "userId": 0,
 "userLogin": "string"
 }
 */
extension ServerModels {

  enum Checkin {

    class Request: ServerModel {

    }

    class Response: ServerModel {
      var checkinTime: String?
      var checkinTimeEpoch: Double?
      var id: Int?
      var message: String?
    }

  }

}
