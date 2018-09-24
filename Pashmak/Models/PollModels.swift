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
    class PollItem: ServerModel {
      class PollAnswer: ServerModel {
        var id: UInt64 = .random(in: 1_000...100_000)
        var title: String = ""
        var imgsrc: String?
        var number: UInt?
        var voted: Bool? {
          didSet {
            itemChangedHandler?()
            pollItemChangeHandler?()
          }
        }
        var itemChangedHandler: ButtonAction?
        var pollItemChangeHandler: ButtonAction?
        var isSubmitting: Bool = false {
          didSet {
            itemChangedHandler?()
            pollItemChangeHandler?()
          }
        }

        enum CodingKeys: String, CodingKey {
          case id, title, imgsrc, number, voted
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

        let total = UInt(answerLimit)
        let votes = UInt(answers?.filter { $0.voted == true || $0.isSubmitting == true }.count ?? 0)

        return total - votes
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

extension ServerModels.Poll.PollItem: ListDiffable {

  func diffIdentifier() -> NSObjectProtocol {
    return self.id as NSObjectProtocol
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? ServerModels.Poll.PollItem else {
      return false
    }

    let itemsEqual = object.answers?.elementsEqual(self.answers ?? []) {
        var result = $0.number == $1.number
        result = result && ($0.id == $1.id)
        result = result && ($0.title == $1.title)
        result = result && ($0.imgsrc == $1.imgsrc)
        result = result && ($0.voted == $1.voted)
        result = result && ($0.isSubmitting == $1.isSubmitting)
      return result
    } ?? true

    return object.id == self.id
      && object.question == self.question
      && object.answerLimit == self.answerLimit
      && object.anonymous == self.anonymous
      && object.imgsrc == self.imgsrc
      && object.isLoading == self.isLoading
      && itemsEqual

  }

}
