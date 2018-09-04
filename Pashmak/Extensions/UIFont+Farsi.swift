//
//  UIFont+Fars.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/21/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import UIKit

enum FarsiFontWeight {
  case regular
  case light
  case bold

  fileprivate var fontName: String {
    switch self {
    case .regular:
      return "IRANSansDNFaNum"
    case .light:
      return "IRANSansDNFaNum-Light"
    case .bold:
      return "IRANSansDNFaNum-Bold"
    }
  }

}

extension UIFont {
  static func farsiFont(_ weight: FarsiFontWeight = .regular, size: CGFloat = 14.0) -> UIFont {
    return UIFont(name: weight.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
  }
}
