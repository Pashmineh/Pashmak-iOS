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

      guard !Settings.current.oauthToken.isEmpty else {
        let error = APIError.invalidParameters("OAuthToken")
        seal.reject(error)
        return
      }

      let request = ServerModels.Checkin.Request()
      PashmakServer.perform(request: ServerRequest.Checkin.checkin(info: request), validResponseCodes: [200, 201])
        .done({ (result: ServerData<ServerModels.Checkin.Response>) in
          let response = result.model
          response.message = response.message ?? "ورود شما برای امروز ثبت شد."
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
