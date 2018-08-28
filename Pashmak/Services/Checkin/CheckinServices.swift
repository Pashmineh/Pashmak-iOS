//
//  CheckinServices.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/28/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
import PromiseKit

class CheckinServices {

  static let shared = CheckinServices()

  func checkInNow() -> Promise<ServerModels.Checkin.Response?> {

    return Promise { seal in

      let request = ServerModels.Checkin.Request()
      PashmakServer.perform(request: ServerRequest.Checkin.checkin(info: request), validResponseCodes: [200, 201])
        .done({ (result: ServerData<ServerModels.Checkin.Response>) in
          let response = result.model
          Checkin.addCheckin(response)
          seal.fulfill(response)
        })
        .catch({ (error) in
          Log.error("Error cheking in.\n\(error)")
          seal.reject(error)
        })

    }

  }

}
