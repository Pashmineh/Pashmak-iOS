//
//  PollModels.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/17/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import IGListKit
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
        var poll: PollItem?

      }

      var answerLimit: UInt8 = 1
      var id: UInt64 = .random(in: 1_000...100_000)
      var question: String = ""
      var pollItemSet: [PollAnswer]? = []
      var isLoading: Bool? = false
      var totalVote: UInt?
      var remainingVotes: UInt {

        let total = UInt(answerLimit)
        let votes = UInt(pollItemSet?.reduce(0) {
          if $1.poll != nil {
            return ($0 ?? 0) + 1
          }
          return $0 ?? 0
        } ?? 0)

        return total - votes
      }
      var anonymous: Bool?
      var imgsrc: String?

      init() {
        self.isLoading = true
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

    return object.id == self.id
      && object.question == self.question
      && object.answerLimit == self.answerLimit
      && object.anonymous == self.anonymous
      && object.imgsrc == self.imgsrc
      && object.isLoading == self.isLoading
      && object.pollItemSet?.elementsEqual(self.pollItemSet ?? []) {
        $0.number == $1.number
          && $0.id == $1.id
          && $0.title == $1.title
          && $0.imgsrc == $1.imgsrc

      } ?? true

  }

}
