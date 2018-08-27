//
//  UIView+Extensions.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/27/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import UIKit

extension UIView {

  func setShadow(opacity: Float, radius: CGFloat, color: UIColor = .black, offset: CGSize = .zero) {
    let layer = self.layer
    layer.shadowColor = color.cgColor
    layer.shadowOffset = offset
    layer.shadowRadius = radius
    layer.shadowOpacity = opacity
  }

}
