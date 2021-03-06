//
//  SplashModels.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/21/18.
//  Copyright (c) 2018 Mohammad Porooshani. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Splash {
  enum GoNext {
    enum Destination {
      case login
      case home
    }

    struct Request {

    }

    struct Response {
      let destination: Destination
    }

    struct ViewModel {
      let destination: Destination
    }
  }

}
