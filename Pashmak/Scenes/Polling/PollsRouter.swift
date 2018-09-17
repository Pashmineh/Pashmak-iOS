//
//  PollsRouter.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/17/18.
//  Copyright (c) 2018 Mohammad Porooshani. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol PollsRoutingLogic {

}

protocol PollsDataPassing {
  var dataStore: PollsDataStore? { get }
}

class PollsRouter: NSObject, PollsRoutingLogic, PollsDataPassing {
  weak var viewController: PollsViewController?
  var dataStore: PollsDataStore?

}
