//
//  URLPath.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity
import Foundation

private let kBaseURL: String = {
  #if DEBUG
//  return "http://178.128.195.55:8080"
//  return "http://pashmak.kian.digital:8080"
  return "http://192.168.60.3:8080"
  #else
//  return "http://178.128.195.55:8080"
//  return "http://pashmak.kian.digital:8080"
  return "http://192.168.60.3:8080"
  #endif
}()

enum URLPath {

  case api
  case profile
  case login
  case home
  case checkin
  case checkins
  case updatePush
  case messages
  case polls
  case vote
  case debts
  case payments

  func toString() -> String {
    var result = ""
    switch self {
    case .api:
      result = "api"
    case .profile:
      result = "profile"
    case .login:
      result = "login"
    case .home:
      result = "home"
    case .checkin:
      result = "checkin"
    case .checkins:
      result = "checkins"
    case .updatePush:
      result = "token"
    case .messages:
      result = "messages"
    case .polls:
      result = "polls"
    case .vote:
      result = "vote"
    case .debts:
      result = "debts"
    case .payments:
      result = "payments"
    }

    return result
  }

}

struct RequestURL {
  static var baseURLString: String {
    return kBaseURL
  }
  private var urlStr: String = kBaseURL

  var url: NSURL? {

    return NSURL(string: self.urlString())
  }

  static func mockRepoURL() -> RequestURL {
    return RequestURL(urlStr: "https://81a99d72-f025-4793-9d46-abab7064efc3.mock.pstmn.io/transactions")
  }

  @discardableResult
  mutating func appendPathComponent(_ path: URLPath) -> RequestURL {
    self.urlStr += "/" +  path.toString()
    return self
  }

  @discardableResult
  mutating func appendPathComponents(_ pathComponents: [URLPath]) -> RequestURL {
    for pathComponent in pathComponents {
      self.appendPathComponent(pathComponent)
    }
    return self
  }

  func urlString() -> String {
    return self.urlStr
  }

}
