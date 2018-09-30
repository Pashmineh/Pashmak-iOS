//
//  AddPaymentTextBulleinPage.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/29/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Async
import BLTNBoard
import Material

class AddTransactionTextBulletinPage: AddPaymentBaseItemPage {

  enum FieldType {
    case amount
    case date
    case refID
    case note

    var placeHolder: String {
      switch self {
      case .amount:
        return "مبلغ (ریال)"
      case .date:
        return "تاریخ"
      case .refID:
        return "کد پیگیری"
      case .note:
        return "توضیحات"
      }
    }

    var keyboardType: UIKeyboardType {
      switch self {
      case .amount, .refID:
        return .asciiCapableNumberPad
      case .date, .note:
        return .default
      }
    }
  }

  var textField: BulletingTextField

  override init(title: String) {
    self.textField = BulletingTextField.textField(for: .amount)
    super.init(title: title)
  }

  convenience init(title: String, fieldType: FieldType) {
    self.init(title: title, actionColor: #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1), actionTitle: "ادامه", showCancel: true)
    self.textField = BulletingTextField.textField(for: fieldType)
  }

  override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
    return [textField]
  }

  override func setUp() {
    super.setUp()
    textField.valueChanged = { [weak self] _ in
      guard let self = self else {
        return
      }
      self.refreshAction()
    }
    refreshAction()
    self.textField.setUp()
  }

  override func tearDown() {
    self.textField.valueChanged = nil
    self.textField.tearDown()
    super.tearDown()
  }

  private func refreshAction() {
    let isValid = textField.isValid
    self.actionButton?.isEnabled = isValid
    self.actionButton?.alpha = isValid ? 1.0 : 0.5
  }

}
