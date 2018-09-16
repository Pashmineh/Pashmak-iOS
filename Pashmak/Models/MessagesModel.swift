//
//  MessagesModel.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/15/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
import IGListKit

private let kDateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.timeStyle = .none
  //2018-08-21T03:00:00Z
  formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss'Z'"
  return formatter
}()

/*
{
  "id": 1151,
  "sendTime": null,
  "messageType": "PUSH",
  "message": "salaaam",
  "userId": 1052,
  "userLogin": "09122214063"
}
*/

extension ServerModels {
  enum Messages {
    enum MessageType: String, Codable {
      case PUSH, SMS, EMAIL
    }
    class ListItem: ServerModel {
      var id: UInt64 = .random(in: 0...100_000)
      var sendTime: String?
      var sendDate: Date {
        guard let sendTime = self.sendTime else {
          return Date()
        }
        return kDateFormatter.date(from: sendTime) ?? Date()
      }
      var messageType: MessageType?
      var message: String?
      var userId: UInt64?
      var userLogin: String?
      var isLoading: Bool? = false

      init() {
        self.isLoading = true
      }
    }
  }
}

extension ServerModels.Messages.ListItem: ListDiffable {
  func diffIdentifier() -> NSObjectProtocol {
    return "\(self.id)" as NSObjectProtocol
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? ServerModels.Messages.ListItem else {
      return false
    }

    return object.id == self.id
    && object.sendTime == self.sendTime
    && object.messageType == self.messageType
    && object.message == self.message
    && object.userId == self.userId
    && object.userLogin == self.userLogin
  }
}
