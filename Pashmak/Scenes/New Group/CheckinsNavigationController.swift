//
//  CheckinsNavigationController.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Material
import SnapKit
import UIKit

class CheckinsNavigationController: NavigationController {

  override var prefersStatusBarHidden: Bool { return false }
  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func prepare() {
    super.prepare()
    prepareNavbar()
  }

  private func prepareNavbar() {
    self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationBar.shadowImage = UIImage()
    self.navigationBar.barTintColor = .clear
    self.navigationBar.isTranslucent = true

  }

}
