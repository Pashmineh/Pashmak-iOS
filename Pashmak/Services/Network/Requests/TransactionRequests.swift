//
//  TransactionRequests.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/26/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

extension ServerRequest {

  enum Transactions {

    static func getTransactions() -> HTTPRequest {
      var url = RequestURL()
      url.appendPathComponents([.transaction])
      let headers: [String: String] =  [HTTPHeaders.Authorization: HTTPHeaderValues.OauthToken].merging(baseRequestHeaders) { current, _ in current }
      return HTTPRequest(method: .GET, url: url, parameters: nil, bodyMessage: nil, headers: headers, timeOut: .normal, acceptType: .json, contentType: .json)
    }

    static func addPayment(payment: ServerModels.Transactions.Item) -> HTTPRequest {
      var url = RequestURL()
      url.appendPathComponents([.transaction])
      let headers: [String: String] =  [HTTPHeaders.Authorization: HTTPHeaderValues.OauthToken].merging(baseRequestHeaders) { current, _ in current }
      return HTTPRequest(method: .POST, url: url, parameters: nil, bodyMessage: payment, headers: headers, timeOut: .normal, acceptType: .json, contentType: .json)
    }

  }

}
