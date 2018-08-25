//
//  BiometricAuthentication.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
import LocalAuthentication
import Async


class BiometricAuthentication {
  
  private static var appDelegate = UIApplication.shared.delegate as? AppDelegate
  
  
  private static let context = LAContext()
  
  static var canEvaluate: Bool {
    return context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
  }
  
  static func confirmWithUser(on VC: UIViewController, onConfirm: @escaping ButtonAction, onReject: @escaping ButtonAction) {
    
    guard canEvaluate else {
      Log.trace("Cannot evaluate so skiped asking user.")
      onReject()
      return
    }
    let title: String = "ورود بدون ورود رمز عبور"
    var message = ""
    switch context.biometryType {
    case .faceID:
      message = "آیا مایلید از این پس با استفاده از تشخیص چهره به اپ کیان دیجیتال وارد شوید؟"
    case .touchID:
      message = "آیا مایلید از این پس با استفاده از اثر انگشت به اپ کیان دیجیتال وارد شوید؟"
    default:
      onReject()
      return
    }
    
    Async.main() {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: "بله", style: UIAlertAction.Style.default, handler: { (_) in
        authenticate(message: "ثبت برای ورود‌های آتی", success: {
          onConfirm()
        }, failure: {
          Log.trace("Culd not evalate user.")
          onReject()
          return
        })
      }))
      alert.addAction(UIAlertAction(title: "خیر", style: UIAlertAction.Style.cancel, handler: { (_) in
        
      }))
      
      VC.present(alert, animated: true, completion: nil)
    }
    
    
  }
  
  static func authenticate(message: String, success: @escaping ButtonAction, failure: @escaping ButtonAction) {
//    appDelegate?.shouldBlur = false
    context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: message) { (ok, error) in
      defer {
//        appDelegate?.shouldBlur = true
      }
      guard error == nil else {
        Log.trace("Error evaluating user!\n\(error?.localizedDescription ?? "")")
        Async.main() {
          
          failure()
        }
        
        return
      }
      
      if ok {
        Async.main() {
          success()
        }
      } else {
        Async.main() {
          failure()
          
        }
        
      }
      
    }
    
  }
  
  
}
