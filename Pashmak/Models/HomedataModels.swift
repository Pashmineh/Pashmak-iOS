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
/*
{
  "cycle": "مهر ۹۷",
  "balance": {
    "balance": -20000,
    "totalPaid": 10000
  },
  "events": [
  {
  "address": {
  "id": "2BF3D3F8-53E7-4050-91A2-DD3FD5EC62AB",
  "title": "Room 2",
  "street": "Alvand St",
  "lat": 12,
  "long": 12,
  "mapImageURL": "http://SomeURL"
  },
  "id": "027305EE-44E6-42FA-9017-4627BD8B00FA",
  "title": "Nahar",
  "imageURL": "SomeURL",
  "description": "Nahar Pashmakian",
  "date": "2018-10-03T13:12:03Z"
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

    class Address: ServerModel {
      var id: String?
      var title: String
      var street: String
      var lat: Double
      var long: Double
      var mapImageURL: String

      static func isEqual(_ lhs: Address?, _ rhs: Address?) -> Bool {
        return lhs?.id == rhs?.id
        && lhs?.title == rhs?.title
        && lhs?.street == rhs?.street
        && lhs?.lat == rhs?.lat
        && lhs?.long == rhs?.long
        && lhs?.mapImageURL == rhs?.mapImageURL
      }

    }

    class Event: ServerModel {
      var id: String?
      var title: String?
      var description: String?
      var imageURL: String?
      var dateEpoch: Double?
      var date: Date? { return dateEpoch?.utcDate }

      var eventDateTime: String {
        guard let date = date else {
          return ""
        }
        return kEventTimeFormatter.string(from: date)
      }
//      var location: String?

      var address: Address?

      var hasPassed: Bool {
        guard let epoch = dateEpoch else {
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

    return object.id == self.id
      && object.title == self.title
      && object.description == self.description
      && object.date == self.date
      &&  ServerModels.Home.Address.isEqual(object.address, self.address)
  }

}
