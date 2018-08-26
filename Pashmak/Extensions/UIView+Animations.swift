//
//  UIView+Animations.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import UIKit
import AudioToolbox

extension UIView {

  func shake(vibrate: Bool = true) {
    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    UIView.animate(withDuration: 0.05, animations: { [weak self] in
      guard let self = self else { return }
      self.transform = CGAffineTransform(translationX: 12.0, y: 0.0)
    }) { [weak self] (_) in
      guard let self = self else { return }
      UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.15, initialSpringVelocity: 0.1, options: [], animations: {
        self.transform = .identity
      }, completion: nil)
    }
  }

}

/*
 func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
 
 guard string.count > 0 else { return true }
 defer {
 validatePhoneNumberAndUpdateNextButton()
 }
 let currentText = textField.text ?? ""
 if currentText.count == 0 {
 if string != "0" {
 self.shakePhoneField()
 return false
 } else {
 self.hideFieldError()
 }
 
 } else if currentText.count == 1 {
 
 if string != "9" {
 self.shakePhoneField()
 return false
 } else {
 self.hideFieldError()
 }
 
 } else {
 numberOfShake = 0
 }
 return 11 > (textField.text ?? "").count
 }
 */
