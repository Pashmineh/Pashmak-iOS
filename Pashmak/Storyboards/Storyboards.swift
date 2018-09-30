//
//  Storyboards.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/21/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import UIKit

enum Storyboards {

  static let Main = UIStoryboard(name: "Main", bundle: nil)

}

enum StoryboardsIDs {

  enum Main {
    static let Login = "LoginStoryboardID"
    static let MainTabbar = "MainTabbarController"
    static let Home = "HomeViewControllerStoryboardID"
    static let AddTransaction = "AddTransactionStoryboardID"
  }

}
