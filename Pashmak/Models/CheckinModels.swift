//
//  CheckinModels.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/28/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
import IGListKit

private let kDateFormatter = DateFormatter.farsiDateFormatter(with: "EEEE، dd MMMM YYYY")
private let kTimeFormatter = DateFormatter.farsiDateFormatter(with: "HH:mm")
private let kTimeFormatterForPenalty: DateFormatter = {
  let formatter = DateFormatter()
  formatter.timeZone = TimeZone.autoupdatingCurrent
  formatter.timeStyle = .none
  formatter.dateFormat = "HH"
  return formatter
}()


/*
 {
 "checkinTime": "2018-08-28T06:05:19.952Z",
 "id": 0,
 "message": "string",
 "userId": 0,
 "userLogin": "string"
 }
 */
/*
 {
 "id": 3201,
 "checkinTime": "2018-08-29T11:42:16.363Z",
 "checkinTimeEpoch": 1535542936000,
 "message": null,
 "userId": 1052,
 "checkinType": null,
 "userLogin": "09122214063"
 }
 */
extension ServerModels {

  enum Checkin {
    enum CheckinType: String, Codable {
      case manual = "MANUAL"
      case iBeacon = "IBEACON"
    }

    class Request: ServerModel {
      let type: CheckinType

      init(type: CheckinType) {
        self.type = type
      }
    }

    class Response: ServerModel {
      var checkinTime: String?
      var checkinTimeEpoch: Double?
      var id: Int?
      var message: String?
    }

    class ListItem: ServerModel {
      var id: UInt64 = .random(in: 0...100_000)
      var checkinTimeEpoch: Double?
      var checkinDate: Date {
        return checkinTimeEpoch?.utcDate ?? Date()
      }
      var message: String?
      var userId: UInt64?
      var checkinType: CheckinType?
      var userLogin: String?

      var isLoading: Bool = false
      var checkinDateString: String {
        return kDateFormatter.string(from: self.checkinDate)
      }

      var checkinTimeString: String {
        return  kTimeFormatter.string(from: self.checkinDate)
      }

      var hasPenalty: Bool {
        let hourString = kTimeFormatterForPenalty.string(from: checkinDate)
        let hour = Int(hourString) ?? 0
        return hour >= 10
      }

      init() {
        self.isLoading = true
      }

      enum CodingKeys: String, CodingKey {
        case id, checkinTimeEpoch, message, userId, checkinType, userLogin
      }
    }

  }

}

extension ServerModels.Checkin.ListItem: ListDiffable {

  func diffIdentifier() -> NSObjectProtocol {
    return "\(self.id)" as NSObjectProtocol
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? ServerModels.Checkin.ListItem else {
      return false
    }

    return object.id == self.id
    && object.checkinTimeEpoch == self.checkinTimeEpoch
    && object.checkinType == self.checkinType
    && object.message == self.message
    && object.userId == self.userId
  }

}
