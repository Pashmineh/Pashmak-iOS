//
//  MessagesPresenter.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/16/18.
//  Copyright (c) 2018 Mohammad Porooshani. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import IGListKit
import UIKit

protocol MessagesPresentationLogic {
func presentPopulate(response: Messages.Populate.Response)
}

class MessagesPresenter: MessagesPresentationLogic {
  weak var viewController: MessagesDisplayLogic?

  func presentPopulate(response: Messages.Populate.Response) {
    let state = response.state
    switch state {
    case .loading:
      var items: [ListDiffable] = []

      (0...8).forEach { _ in
        let loadingMessage = ServerModels.Messages.ListItem()
        items.append(loadingMessage)
      }

      let viewModel = Messages.Populate.ViewModel.Loading(items: items)
      viewController?.displayPopulateLoading(viewModel: viewModel)
    case .failure(let error):
      var message = "خطا در دریافت اطلاعات!"
      if case APIError.invalidResponseCode(let statusCode) = error {
        message = Texts.ServerErrors.random + "\n(\(statusCode))"
      }
      let viewModel = Messages.Populate.ViewModel.Failed(message: message)
      viewController?.displayPopulateFailed(viewModel: viewModel)
    case .success(let messages):
      let viewModel = Messages.Populate.ViewModel.Success(items: messages)
      viewController?.displayPopulateSuccess(viewModel: viewModel)
    }
  }
}
