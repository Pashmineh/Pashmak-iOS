//
//  HomePresenter.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/26/18.
//  Copyright (c) 2018 Mohammad Porooshani. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import IGListKit

protocol HomePresentationLogic {
  func presentPopulate(response: Home.Populate.Response)
  func presentRefresh(response: Home.Refresh.Response)
}

class HomePresenter: HomePresentationLogic {
  weak var viewController: HomeDisplayLogic?
  func presentPopulate(response: Home.Populate.Response) {

    let state = response.state

    switch state {
    case .loading:
      let message = Messages.Loading.messages.randomElement() ?? "در حال خوندن اطلاعات..."
      let viewModel = Home.Populate.ViewModel.Loading.init(message: message, items: [HomeSkeletonItem()])
      viewController?.displayPopulateLoading(viewModel: viewModel)
    case .failure(let error):
      var message = "خطا!"
      if case APIError.invalidResponseCode(let status) = error {
        message = Messages.ServerErrors.messages.randomElement() ?? message
        message += "\n\(status)"
      }
      let viewModel = Home.Populate.ViewModel.Failed.init(message: message)
      viewController?.displayPopulateFailed(viewModel: viewModel)
    case .success(let homeData):
      let profile = Home.UserProfile(homeData: homeData, settings: Settings.current)
      var items: [ListDiffable] = []
      if let events = homeData.events?.sorted(by: { ($0.eventTimeEpoch ?? 0) < ($1.eventTimeEpoch ?? 0) }) {
        events.forEach { items.append($0) }
      }
      let viewModel = Home.Populate.ViewModel.Success.init(profile: profile, items: items)
      viewController?.displayPopulateSuccess(viewModel: viewModel)
    }

  }

  func presentRefresh(response: Home.Refresh.Response) {
    let state = response.state

    switch state {
    case .loading:
      break
    case .failure(let error):
      var message = "خطا!"
      if case APIError.invalidResponseCode(let status) = error {
        message = Messages.ServerErrors.messages.randomElement() ?? message
        message += "\n\(status)"
      }
      let viewModel = Home.Refresh.ViewModel.Failed(message: message)
      viewController?.displayRefreshFailed(viewModel: viewModel)
    case .success(let homeData):
      let profile = Home.UserProfile(homeData: homeData, settings: Settings.current)
      var items: [ListDiffable] = []
      if let events = homeData.events?.sorted(by: { ($0.eventTimeEpoch ?? 0) < ($1.eventTimeEpoch ?? 0) }) {
        events.forEach { items.append($0) }
      }
      let viewModel = Home.Refresh.ViewModel.Success(profile: profile, items: items)
      viewController?.displayRefreshSuccess(viewModel: viewModel)
    }
  }
}
