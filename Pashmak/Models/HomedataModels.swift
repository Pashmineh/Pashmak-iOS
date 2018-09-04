//
//  HomedataModles.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/27/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
import IGListKit
import SwiftDate
/*
{
  "balance": {
    "balance": 0,
    "totalPaid": 0
  },
  "cycle": "string",
  "events": [
  {
  "description": "string",
  "eventTime": "2018-08-26T20:05:02.495Z",
  "id": 0,
  "location": "string",
  "name": "string"
  }
  ]
}
*/

private let kEventTimeFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.locale = Locale(identifier: "fa_IR")
  formatter.calendar = Calendar(identifier: .persian)
  formatter.timeZone = TimeZone.autoupdatingCurrent
  formatter.timeStyle = .none
  formatter.dateFormat = "EEEE dd MMMM YY | ساعت HH:mm"
  return formatter
}()

extension ServerModels {

  class Home: ServerModel {
    class Balance: ServerModel {
      var balance: Int64?
      var totalPaid: Int64?
    }

    class Event: ServerModel {
      var id: Int64?
      var name: String?
      var description: String?
      var eventTime: String?
      var eventTimeEpoch: Double?
      var location: String?

      var eventDateTime: String {
        guard let epoch = eventTimeEpoch else {
          return ""
        }
        return kEventTimeFormatter.string(from: epoch.utcDate)
      }

      var hasPassed: Bool {
        guard let epoch = eventTimeEpoch else {
          return false
        }
        return epoch.utcDate.isBeforeDate(Date(), granularity: Calendar.Component.hour)
      }

    }

    var balance: Balance?
    var cycle: String?
    var events: [Event]?
  }

}

extension ServerModels.Home.Event: ListDiffable {

  func diffIdentifier() -> NSObjectProtocol {
    guard let id = self.id else {
      return UUID().uuidString as NSObjectProtocol
    }
    return "\(id)" as NSObjectProtocol
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? ServerModels.Home.Event else {
      return false
    }

    return object.id == self.id && object.name == self.name && object.description == self.description && object.eventTime == self.eventTime && object.location == self.location
  }

}
