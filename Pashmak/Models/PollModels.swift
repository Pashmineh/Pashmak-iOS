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
      }

      var answerLimit: UInt8 = 1
      var id: UInt64 = .random(in: 1_000...100_000)
      var question: String = ""
      var pollItemSet: [PollAnswer]? = []
      var isLoading: Bool? = false

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
      && object.pollItemSet?.elementsEqual(self.pollItemSet ?? []) {
        $0.id == $1.id
        && $0.title == $1.title
      } ?? true

  }

}
