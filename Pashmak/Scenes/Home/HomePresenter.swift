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

import IGListKit
import SwiftDate
import UIKit

protocol HomePresentationLogic {
  func presentPopulate(response: Home.Populate.Response)
  func presentRefresh(response: Home.Refresh.Response)
  func presentSignout(response: Home.Signout.Response)
}

class HomePresenter: HomePresentationLogic {
  weak var viewController: HomeDisplayLogic?

  func presentPopulate(response: Home.Populate.Response) {

    let state = response.state

    switch state {
    case .loading:
      let message = Texts.Loading.random
      let viewModel = Home.Populate.ViewModel.Loading(message: message, items: [HomeSkeletonItem()])
      viewController?.displayPopulateLoading(viewModel: viewModel)
    case .failure(let error):
      var message = "خطا!"
      if case APIError.invalidResponseCode(let status) = error {
        message = Texts.ServerErrors.random
        message += "\n\(status)"
      }
      let viewModel = Home.Populate.ViewModel.Failed(message: message)
      viewController?.displayPopulateFailed(viewModel: viewModel)
    case .success(let homeData):
      let profile = Home.UserProfile(homeData: homeData, settings: Settings.current)
      var items: [ListDiffable] = []
      if let events = homeData.events?.sorted(by: { ($0.dateEpoch ?? 0) < ($1.dateEpoch ?? 0) }) {
        events/*.filter {
          $0.date?.isAfterDate(Date().dateByAdding(-14, Calendar.Component.day).date, granularity: Calendar.Component.day) ?? false
        }*/
        .forEach {
          items.append($0)
        }
      }

      let needsCheckin = !Checkin.checkedInToday
      let viewModel = Home.Populate.ViewModel.Success(profile: profile, needsCheckIn: needsCheckin, items: items)
      viewController?.displayPopulateSuccess(viewModel: viewModel)
    }

  }

  func presentRefresh(response: Home.Refresh.Response) {
    let state = response.state
    let isInBack = response.isInBackground
    switch state {
    case .loading:
      break
    case .failure(let error):
      var message = "خطا!"
      if case APIError.invalidResponseCode(let status) = error {
        message = Texts.ServerErrors.random
        message += "\n\(status)"
      }
      let viewModel = Home.Refresh.ViewModel.Failed(message: message, isInBackground: isInBack)
      viewController?.displayRefreshFailed(viewModel: viewModel)
    case .success(let homeData):
      let profile = Home.UserProfile(homeData: homeData, settings: Settings.current)
      var items: [ListDiffable] = []
      if let events = homeData.events?.sorted(by: { ($0.dateEpoch ?? 0) < ($1.dateEpoch ?? 0) }) {
        events/*.filter {
          $0.dateEpoch?.utcDate.isAfterDate(Date().dateByAdding(-14, Calendar.Component.day).date, granularity: Calendar.Component.day) ?? false
        }*/.forEach { items.append($0) }
      }
      let viewModel = Home.Refresh.ViewModel.Success(profile: profile, items: items)
      viewController?.displayRefreshSuccess(viewModel: viewModel)
    }
  }

  func presentSignout(response: Home.Signout.Response) {
    let viewModel = Home.Signout.ViewModel()
    viewController?.displaySignout(viewModel: viewModel)
  }
/*
  func presentCheckin(response: Home.Checkin.Response) {
    let state = response.state
    let isRanging = response.isRanging
    switch state {
    case .loading:
      let message = isRanging ? Texts.Ranging.random : Texts.Loading.random
      let viewModel = Home.Checkin.ViewModel.Loading(message: message)
      viewController?.displayCheckinLoading(viewModel: viewModel)
    case .failure(let error):

      var message = "خطا در عملیات!"
      if isRanging {
        message = Texts.RangingError.random
      } else {
        if case APIError.invalidPrecondition(let msg) = error {
          message = msg
        } else if case APIError.invalidResponseCode(let status) = error {
          message = Texts.ServerErrors.random + "\n(\(status))"
        }
      }

      let viewModel = Home.Checkin.ViewModel.Failed(message: message)
      viewController?.displayCheckinFailed(viewModel: viewModel)

    case .success(let message):
      let viewModel = Home.Checkin.ViewModel.Success(message: message)
      viewController?.displayCheckinSuccess(viewModel: viewModel)
    }
  }

  func presentCheckinUpdate(response: Home.UpdateChekinButton.Response) {
    let needsCheckin = response.needsChekin
    let viewModel = Home.UpdateChekinButton.ViewModel(needsChekin: needsCheckin)
    viewController?.displayCheckinUpdate(viewModel: viewModel)
  }

 */
}
