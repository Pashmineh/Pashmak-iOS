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
/*
[
  {
    "expirationDate": 1538733329.5644269,
    "pollItems": [
    {
    "id": "C09CECEB-E0D9-479E-A178-E382BDDF3B12",
    "title": "محمد",
    "isVoted": false,
    "votesCount": 1
    }
    ],
    "id": "214FE00D-E9A7-41C8-97C0-C9744C596324",
    "title": "انتخابات هیات رئیسه",
    "isAnonymous": false,
    "description": "به نظر شما چه کسانی لیاقت حضور در هیات رئیسه را دارند؟",
    "voteLimit": 3,
    "totalVotes": 1
  },
  {
    "expirationDate": 1538740496.491662,
    "pollItems": [
    {
    "id": "91D91A82-2D8C-4EA0-9242-DFF928AB1354",
    "title": "فرزاد",
    "isVoted": false,
    "votesCount": 1
    },
    {
    "id": "5E418FC1-D9C2-4DAE-AE01-39615DDED6FB",
    "title": "میلاد",
    "isVoted": false,
    "votesCount": 2
    },
    {
    "id": "55063816-0048-4BE8-A584-467B2CA1C07D",
    "title": "میلاد",
    "isVoted": false,
    "votesCount": 0
    }
    ],
    "id": "DBBCAD23-1A4A-4BF3-AE71-CCFE8D26EF0D",
    "title": "انتخابات هیات رئیسه",
    "isAnonymous": false,
    "description": "به نظر شما چه کسانی لیاقت حضور در هیات رئیسه را دارند؟",
    "voteLimit": 2,
    "totalVotes": 2
  }
]
 */

/*
{
  "pollItems": [
  {
  "id": "91D91A82-2D8C-4EA0-9242-DFF928AB1354",
  "title": "فرزاد",
  "isVoted": false,
  "votesCount": 1
  },
  {
  "id": "5E418FC1-D9C2-4DAE-AE01-39615DDED6FB",
  "title": "میلاد",
  "isVoted": false,
  "votesCount": 2
  },
  {
  "id": "55063816-0048-4BE8-A584-467B2CA1C07D",
  "title": "میلاد",
  "isVoted": true,
  "votesCount": 1
  }
  ],
  "id": "DBBCAD23-1A4A-4BF3-AE71-CCFE8D26EF0D",
  "title": "انتخابات هیات رئیسه",
  "expirationDateEpoch": 1538740496491.6621,
  "isAnonymous": false,
  "description": "به نظر شما چه کسانی لیاقت حضور در هیات رئیسه را دارند؟",
  "voteLimit": 2,
  "totalVotes": 3
}
 */
extension ServerModels {

  enum Poll {
    struct PollItem: ServerModel {
      struct PollAnswer: ServerModel {
        var id: String = UUID().uuidString
        var title: String = ""
        var imageSrc: String?
        var votesCount: UInt = 0
        var isVoted: Bool?
        var isSubmitting: Bool = false

        enum CodingKeys: String, CodingKey {
          case id, title, imageSrc, votesCount, isVoted
        }

        static func == (lhs: PollAnswer, rhs: PollAnswer) -> Bool {
          return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.imageSrc == rhs.imageSrc
            && lhs.votesCount == rhs.votesCount
            && lhs.isVoted == rhs.isVoted
            && lhs.isSubmitting == rhs.isSubmitting
        }
      }

      var id: String = UUID().uuidString
      var voteLimit: UInt8 = 1
      var description: String = ""
      var pollItems: [PollAnswer]? = []
      var totalVotes: UInt?
      var isAnonymous: Bool?
      var imageSrc: String?
      var title: String?
      var expirationDateEpoch: Double?
      var expirationDate: Date? { return expirationDateEpoch?.utcDate }

      var isLoading: Bool = false
      var remainingVotes: UInt {

        let total = Int(voteLimit)
        let votes = Int(pollItems?.filter { $0.isVoted == true || $0.isSubmitting == true }.count ?? 0)

        return UInt(max(total - votes, 0))
      }

      var canVote: Bool {
        let answers = self.pollItems?.filter { $0.isVoted == true }.count ?? 0
        let pending = self.pollItems?.filter { $0.isVoted != true && $0.isSubmitting == true }.count ?? 0
        return voteLimit > (answers + pending)
      }

      init() {
        self.isLoading = true
      }

      enum CodingKeys: String, CodingKey {
        case id, voteLimit, description, totalVotes, isAnonymous, imageSrc, expirationDateEpoch, pollItems
      }

    }

    struct VoteRequest: ServerModel {
      let itemId: String
    }
    class Vote: ServerModel {
      let item: String
      let poll: String

      var voteRequest: VoteRequest { return VoteRequest(itemId: self.item) }

      init(pollID: String, itemID: String) {
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
      && lhs.title == rhs.title
      && lhs.description == rhs.description
      && lhs.isAnonymous == rhs.isAnonymous
      && lhs.imageSrc == rhs.imageSrc
      && lhs.voteLimit == rhs.voteLimit
      && lhs.expirationDateEpoch == rhs.expirationDateEpoch
      && (lhs.pollItems?.elementsEqual(rhs.pollItems ?? [], by: ==) ?? true)
  }

  var listDiffable: ListDiffable {
    return DiffableBox(value: self, identifier: self.id as NSObjectProtocol, equal: ==)
  }

}
