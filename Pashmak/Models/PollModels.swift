//
//  PollModels.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/17/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import IGListKit
import RxSwift
/*
[
  {
    "anonymous": true,
    "answerLimit": 0,
    "id": 0,
    "imgsrc": "string",
    "pollItemSet": [
    {
    "id": 0,
    "imgsrc": "string",
    "number": 0,
    "poll": {
    "anonymous": true,
    "answerLimit": 0,
    "id": 0,
    "imgsrc": "string",
    "pollItemSet": [
    {}
    ],
    "question": "string",
    "totalVote": 0
    },
    "title": "string"
    }
    ],
    "question": "string",
    "totalVote": 0
  }
]
*/
/*
[
  {
    "answerLimit": 0,
    "id": 0,
    "pollItemSet": [
    {
    "id": 0,
    "title": "string"

    }
    ],
    "question": "string"
  }
]
 */
extension ServerModels {

  enum Poll {
    struct PollItem: ServerModel {
      struct PollAnswer: ServerModel {
        var id: UInt64 = .random(in: 1_000...100_000)
        var title: String = ""
        var imgsrc: String?
        var number: UInt?
        var voted: Bool?
        var isSubmitting: Bool = false

        enum CodingKeys: String, CodingKey {
          case id, title, imgsrc, number, voted
        }

        static func == (lhs: PollAnswer, rhs: PollAnswer) -> Bool {
          return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.imgsrc == rhs.imgsrc
            && lhs.number == rhs.number
            && lhs.voted == rhs.voted
            && lhs.isSubmitting == rhs.isSubmitting
        }
      }

      var answerLimit: UInt8 = 1
      var id: UInt64 = .random(in: 1_000...100_000)
      var question: String = ""
      var answers: [PollAnswer]? = []
      var totalVote: UInt?
      var anonymous: Bool?
      var imgsrc: String?

      var isLoading: Bool = false
      var remainingVotes: UInt {

        let total = Int(answerLimit)
        let votes = Int(answers?.filter { $0.voted == true || $0.isSubmitting == true }.count ?? 0)

        return UInt(max(total - votes, 0))
      }

      var canVote: Bool {
        let answers = self.answers?.filter { $0.voted == true }.count ?? 0
        let pending = self.answers?.filter { $0.voted != true && $0.isSubmitting == true }.count ?? 0
        return answerLimit > (answers + pending)
      }

      init() {
        self.isLoading = true
      }

      enum CodingKeys: String, CodingKey {
        case id, answerLimit, question, totalVote, anonymous, imgsrc
        case answers = "itemDTOS"

      }

    }

    class Vote: ServerModel {
      let item: UInt64
      let poll: UInt64

      init(pollID: UInt64, itemID: UInt64) {
        self.item = itemID
        self.poll = pollID
      }
    }
  }

}

extension ServerModels.Poll.PollItem: Diffable {

  var diffIdentifier: String {
    return "\(self.id)"
  }

  static func == (lhs: ServerModels.Poll.PollItem, rhs: ServerModels.Poll.PollItem) -> Bool {
    return lhs.id == rhs.id
      && lhs.isLoading == rhs.isLoading
      && lhs.question == rhs.question
      && lhs.anonymous == rhs.anonymous
      && lhs.imgsrc == rhs.imgsrc
      && lhs.answerLimit == rhs.answerLimit
      && (lhs.answers?.elementsEqual(rhs.answers ?? [], by: ==) ?? true)
  }

  var listDiffable: ListDiffable {
    return DiffableBox(value: self, identifier: self.id as NSObjectProtocol, equal: ==)
  }

}
