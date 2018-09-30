//
//  AddTransactionTypeSelectionPage.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/29/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import BLTNBoard
import Material
import TextImageButton
import UIKit

class AddTransactionTypeSelectionPage: AddPaymentBaseItemPage {

  var buttons: [ButtonDescriptor] = []

  init(title: String, buttons: [ButtonDescriptor]) {
    super.init(title: title)
    self.buttons = buttons
  }

  override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {

    let stack = interfaceBuilder.makeGroupStack(spacing: 12.0)

    self.buttons.forEach {
      let buttonWrapper = interfaceBuilder.makeMaterialActionButton(title: $0.title, image: $0.image, page: self, action: $0.action)
      stack.addArrangedSubview(buttonWrapper)
    }

    return [stack]
  }

}

extension BLTNInterfaceBuilder {

  /// Test
  func makeMaterialActionButton(title: String, image: UIImage?, page: BLTNPageItem, action: BulletinAction? = nil) -> BLTNMaterialButtonWrapper {
    let actionButton = TextImageButton()
//    actionButton.set(image: image, title: title, titlePosition: .left, additionalSpacing: 6.0, state: [])
    actionButton.setImage(image, for: [])
    actionButton.layer.cornerRadius = 12.0
    actionButton.backgroundColor = .white//appearance.actionButtonColor
    actionButton.layer.borderWidth = 1.0 / Screen.scale
    actionButton.layer.borderColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
    actionButton.setTitleColor(#colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1), for: .normal)

    actionButton.contentHorizontalAlignment = .center
    actionButton.pulseColor = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)
    actionButton.setTitle(title, for: .normal)
//    actionButton.titleLabel?.font = appearance.makeActionButtonFont()
    actionButton.imagePosition = .right
    actionButton.spacing = 6.0
    actionButton.titleLabel?.font = UIFont.farsiFont(.light, size: 16.0)
    actionButton.clipsToBounds = true
    actionButton.touchUp = {
      action?(page)
    }

    let wrapper = BLTNMaterialButtonWrapper(button: actionButton)
    wrapper.setContentHuggingPriority(.defaultLow, for: .horizontal)

    let heightConstraint = wrapper.heightAnchor.constraint(equalToConstant: 55)
    heightConstraint.priority = .defaultHigh
    heightConstraint.isActive = true

    return wrapper
  }

}

@objc
 public class BLTNMaterialButtonWrapper: UIView {

  @objc public let button: Button

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is unavailable. Use init(button:) instead.")
  }

  init(button: Button) {

    self.button = button
    super.init(frame: .zero)

    addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    button.topAnchor.constraint(equalTo: topAnchor).isActive = true
    button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

  }

  override public var intrinsicContentSize: CGSize {
    return button.intrinsicContentSize
  }

}
