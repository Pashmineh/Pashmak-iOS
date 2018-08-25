//
//  LoginModels.swift
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

enum Login
{
  enum Verify{
    struct Request {
      let phone: String
      let nationalID: String
    }
    
    struct Response {
      let phoneIsValid: Bool
      let nationalIdIsValid: Bool
    }
    
    struct ViewModel {
      let phoneIsValid: Bool
      let nationalIdIsValid: Bool
    }
  }

}
