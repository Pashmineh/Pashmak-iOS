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
    static let voteUpdateReceived: Notification.Name = Notification.Name("VoteUpdated")
    static let messageUpdateReceived: Notification.Name = Notification.Name("messagesUpdated")
    static let homeUpdateReceived: Notification.Name = Notification.Name("homeUpdated")
    static let profileUpdateReceived: Notification.Name = Notification.Name("profileUpdated")
    static let transactionUpdateReceived: Notification.Name = Notification.Name("transactionUpdated")
    static let eventUpdateReceived: Notification.Name = Notification.Name("eventsUpdated")
  }

}



struct UpdatePushModel: Codable {
  enum UpdateType: String, Codable {
    case profile = "PROFILE"
    case messages = "MESSAGES"
    case checkin = "CHECKIN"
    case transaction = "TRANSACTION"
    case home = "HOME"
    case poll = "POLL"
    case event = "EVENT"
  }

  enum EventType: String, Codable {
    case create = "CREATE"
    case update = "UPDATE"
    case delete = "DELETE"
  }

  var type: UpdateType?
  var event: EventType?

}
