//
//  Controls.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import UIKit

typealias ButtonAction = () -> Void

fileprivate struct AssociatedKeys {
  static var touchUp = "touchUp"
  static var touchDown = "touchDown"
  static var touchLeave = "touchLeave"
}

fileprivate class ClosureWrapper {
  var closure: ButtonAction?
  
  init(_ closure: ButtonAction?) {
    self.closure = closure
  }
}

extension UIControl {
  
  @objc private func performTouchUp() {
    
    guard let action = touchUp else {
      return
    }
    
    action()
    
  }
  
  @objc private func performTouchDown() {
    
    guard let action = touchDown else {
      return
    }
    
    action()
    
  }
  
  @objc private func performTouchLeave() {
    
    guard let action = touchLeave else {
      return
    }
    
    action()
    
  }
  
  var touchUp: ButtonAction? {
    
    get {
      
      let closure = objc_getAssociatedObject(self, &AssociatedKeys.touchUp)
      guard let action = closure as? ClosureWrapper else{
        return nil
      }
      return action.closure
    }
    
    set {
      if let action = newValue {
        let closure = ClosureWrapper(action)
        objc_setAssociatedObject(
          self,
          &AssociatedKeys.touchUp,
          closure as ClosureWrapper,
          .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        self.addTarget(self, action: #selector(performTouchUp), for: .touchUpInside)
      } else {
        self.removeTarget(self, action: #selector(performTouchUp), for: .touchUpInside)
      }
      
    }
  }
  
  
  var touchDown: ButtonAction? {
    
    get {
      
      let closure = objc_getAssociatedObject(self, &AssociatedKeys.touchDown)
      guard let action = closure as? ClosureWrapper else{
        return nil
      }
      return action.closure
    }
    
    set {
      if let action = newValue {
        let closure = ClosureWrapper(action)
        objc_setAssociatedObject(
          self,
          &AssociatedKeys.touchDown,
          closure as ClosureWrapper,
          .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        self.addTarget(self, action: #selector(performTouchDown), for: .touchDown)
      } else {
        self.removeTarget(self, action: #selector(performTouchDown), for: .touchDown)
      }
      
    }
  }
  
  var touchLeave: ButtonAction? {
    
    get {
      
      let closure = objc_getAssociatedObject(self, &AssociatedKeys.touchLeave)
      guard let action = closure as? ClosureWrapper else{
        return nil
      }
      return action.closure
    }
    
    set {
      if let action = newValue {
        let closure = ClosureWrapper(action)
        objc_setAssociatedObject(
          self,
          &AssociatedKeys.touchLeave,
          closure as ClosureWrapper,
          .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        self.addTarget(self, action: #selector(performTouchLeave), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
      } else {
        self.removeTarget(self, action: #selector(performTouchLeave), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
      }
      
    }
  }
}


extension UIViewController {
  var previousViewController: UIViewController? {
    guard let vcs = self.navigationController?.viewControllers else { return nil }
    guard vcs.count >= 2 else { return nil }
    return vcs[vcs.endIndex - 2]
  }
}
