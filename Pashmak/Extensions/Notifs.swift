//
//  Notifs.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/28/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

extension Notification.Name {

  enum Pashmak {
    static let UpdateReceievd: Notification.Name = Notification.Name("UpdateReceived")
    static let checkinUpdated: Notification.Name = Notification.Name("ChekinUpdated")
  }

}
