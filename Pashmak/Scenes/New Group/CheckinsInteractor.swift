//
//  CheckinsInteractor.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/25/18.
//  Copyright (c) 2018 Mohammad Porooshani. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Async
import UIKit

protocol CheckinsBusinessLogic {
func populate(request: Checkins.Populate.Request)
}

protocol CheckinsDataStore {

}

class CheckinsInteractor: CheckinsBusinessLogic, CheckinsDataStore {
  var presenter: CheckinsPresentationLogic?

  func populate(request: Checkins.Populate.Request) {

    func sendLoading() {
      let response = Checkins.Populate.Response(state: .loading)
      presenter?.presentPopulate(response: response)
    }

    func senfFailed(_ error: Error) {
      let response = Checkins.Populate.Response(state: .failure(error))
      presenter?.presentPopulate(response: response)
    }
    sendLoading()
    PashmakServer.perform(request: ServerRequest.Checkin.getCheckins())
      .done { [weak self] (result: ServerData<[ServerModels.Checkin.ListItem]>) in
        guard let self = self else {
          return
        }
        let checkins = result.model
        Async.main(after: 0.5) {
          let response = Checkins.Populate.Response(state: .success(checkins))
          self.presenter?.presentPopulate(response: response)
        }
      }
      .catch { error in
        senfFailed(error)
      }
  }
}