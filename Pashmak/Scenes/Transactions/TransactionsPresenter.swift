//
//  TransactionsPresenter.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/26/18.
//  Copyright (c) 2018 Mohammad Porooshani. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import IGListKit
import Material
import UIKit

protocol TransactionsPresentationLogic {
  func presentPopulate(response: Transactions.Populate.Response)
}

class TransactionsPresenter: TransactionsPresentationLogic {
  weak var viewController: TransactionsDisplayLogic?

  func presentPopulate(response: Transactions.Populate.Response) {
    let state = response.state

    switch state {
    case .loading:

      let height: CGFloat = 96.0
      let count = Int((Screen.height / height).rounded(.up))
      var items: [ListDiffable] = []
      (0...count).forEach { _ in
        items.append(ServerModels.Transactions.Item())
      }
      let viewModel = Transactions.Populate.ViewModel.Loading(items: items)
      viewController?.displayPopulateLoading(viewModel: viewModel)
    case .failure(let error):
      var message = "خطا در دریافت اطلاعات!"
      if case APIError.invalidResponseCode(let statusCode) = error {
        message = Texts.ServerErrors.random + "\n(\(statusCode))"
      }
      let viewModel = Transactions.Populate.ViewModel.Failed(message: message)
      viewController?.displayPopulateFailed(viewModel: viewModel)
    case .success(let items):
      let viewModel = Transactions.Populate.ViewModel.Success(items: items)
      viewController?.displayPopulateSuccess(viewModel: viewModel)
    }
  }
}
