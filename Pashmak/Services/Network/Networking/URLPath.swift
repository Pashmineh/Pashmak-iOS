//
//  URLPath.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

fileprivate let baseURL: String = {
  #if DEBUG
    return "http://178.128.195.55"
  #else
    return "http://178.128.195.55"
  #endif
}()


enum URLPath {
  
  case api
  
  func toString() -> String {
    var result = ""
    switch self {
    case .api:
      result = "api/v1"
    }
    return result
  }
  
}

struct RequestURL {
  static var baseURLString: String {
    return baseURL
  }
  private var urlStr: String = baseURL
  
  var url: NSURL? {
    
    return NSURL(string: self.urlString())
  }
  
  static func MockRepoURL() -> RequestURL {
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


