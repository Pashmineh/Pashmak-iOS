//
//  Formatters.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/27/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import UIKit

enum Formatters {
  static let RialFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "fa_IR")
    formatter.numberStyle = .currency
    formatter.currencySymbol = ""
    //  formatter.currencyGroupingSeparator = ","
    formatter.groupingSize = 3
    formatter.alwaysShowsDecimalSeparator = false
    formatter.isLenient = true
    return formatter
  }()

  static let RialFormatterWithRial: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "fa_IR")
    formatter.numberStyle = .currency
    formatter.currencySymbol = ""
    //  formatter.currencyGroupingSeparator = ","
    formatter.groupingSize = 3
    formatter.alwaysShowsDecimalSeparator = false
    formatter.positiveSuffix = " ﷼ "
    formatter.positivePrefix = "\u{200F}"
    formatter.negativeSuffix = "-" + " ﷼ "
    formatter.negativePrefix = "\u{200F}"
    formatter.isLenient = true
    return formatter
  }()

  static let TomanFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "fa_IR")
    formatter.numberStyle = .currency
    formatter.currencySymbol = ""
    //  formatter.currencyGroupingSeparator = ","
    formatter.groupingSize = 3
    formatter.alwaysShowsDecimalSeparator = false
    formatter.positiveSuffix = " تومان "
    formatter.positivePrefix = "\u{200F}"
    formatter.negativeSuffix = "-" + " تومان "
    formatter.negativePrefix = "\u{200F}"
    formatter.isLenient = true
    return formatter
  }()

  static let TomaniFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "fa_IR")
    formatter.numberStyle = .currency
    formatter.currencySymbol = ""
    //  formatter.currencyGroupingSeparator = ","
    formatter.groupingSize = 3
    formatter.alwaysShowsDecimalSeparator = false
    formatter.positiveSuffix = " تومانی "
    formatter.positivePrefix = "\u{200F}"
    formatter.negativeSuffix = "-" + " ﷼ "
    formatter.negativePrefix = "\u{200F}"
    formatter.isLenient = true
    return formatter
  }()

  static let NumberToTextFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "fa_IR")
    formatter.numberStyle = .spellOut
    return formatter
  }()

}
