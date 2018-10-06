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

/*
"body": "پسغام جدید دارید. برید بخونید",
"id": "FFFCD884-CE0A-47A0-8FBE-094307F0F522",
"title": "سلام",
"date": 1538821732.3796301
*/
extension ServerModels {
  enum Messages {
    enum MessageType: String, Codable {
      case PUSH, SMS, EMAIL
    }
    class ListItem: ServerModel {
      var id: String = UUID().uuidString
      var dateEpoch: Double?
      var sendDate: Date {
        return dateEpoch?.utcDate ?? Date()
      }

      var sendTime: String {
        return kDateFormatter.string(from: sendDate)
      }

      var body: String?
      var title: String?
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
    && object.dateEpoch == self.dateEpoch
    && object.title == self.title
    && object.body == self.body

  }
}
