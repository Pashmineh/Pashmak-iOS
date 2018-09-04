//
//  Date+Extensions.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

extension Date {
  var utcValue: Double {
    return self.timeIntervalSince1970 * 1_000.0
  }
}

extension Double {
  var utcDate: Date {
    return Date(timeIntervalSince1970: self / 1_000.0)
  }
}
