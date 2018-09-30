//
//  UITextField+Extensions.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/30/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import UIKit

extension UITextField {

  var selectedRange: NSRange? {

    let beginning = self.beginningOfDocument
    guard let seletcedRange = self.selectedTextRange else {
      return nil
    }

    let selectionStart = seletcedRange.start
    let selectionEnd = seletcedRange.end

    let location = self.offset(from: beginning, to: selectionStart)
    let length = self.offset(from: selectionStart, to: selectionEnd)

    return NSRange(location: location, length: length)

  }

}
