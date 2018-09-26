//
//  TransactionsInteractor.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/26/18.
//  Copyright (c) 2018 Mohammad Porooshani. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Async
import IGListKit
import UIKit

protocol TransactionsBusinessLogic {
  func populate(request: Transactions.Populate.Request)
}

protocol TransactionsDataStore {

}

class TransactionsInteractor: TransactionsBusinessLogic, TransactionsDataStore {
  var presenter: TransactionsPresentationLogic?

  func populate(request: Transactions.Populate.Request) {

    func sendLoading() {
      Async.main { [weak self] in
        guard let self = self else {
          return
        }
        let response = Transactions.Populate.Response(state: .loading)
        self.presenter?.presentPopulate(response: response)
      }
    }

    func sendFailed(_ error: Error) {

      Async.main { [weak self] in
        guard let self = self else {
          return
        }

        let response = Transactions.Populate.Response(state: .failure(error))
        self.presenter?.presentPopulate(response: response)
      }
    }

    sendLoading()

    var items: [ServerModels.Transactions.Item] = []

    func sendResult() {
      Async.main { [weak self] in
        guard let self = self else {
          return
        }
        items.sort { $0.paymentTime ?? "" > $1.paymentTime ?? "" }
        let response = Transactions.Populate.Response(state: .success(items))
        self.presenter?.presentPopulate(response: response)
      }
    }

    func getPayments() {
      PashmakServer.perform(request: ServerRequest.Transactions.getPayments())
        .done { (result: ServerData<[ServerModels.Transactions.Item]>) in
          items.append(contentsOf: result.model)
          sendResult()
        }
        .catch { error in
          sendFailed(error)
        }
    }

    func getDebts() {

      PashmakServer.perform(request: ServerRequest.Transactions.getDebts())
        .done { (result: ServerData<[ServerModels.Transactions.Item]>) in
          let debts = result.model
          debts.forEach { $0.isPenalty = true }
          items.append(contentsOf: debts)
          getPayments()
        }
        .catch { error in
          sendFailed(error)
        }

    }

    getDebts()

  }

}
