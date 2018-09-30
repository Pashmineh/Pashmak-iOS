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

    var placeHolder: String {
      switch self {
      case .amount:
        return "مبلغ (ریال)"
      case .date:
        return "تاریخ"
      }
    }

    var keyboardType: UIKeyboardType {
      switch self {
      case .amount:
        return .asciiCapableNumberPad
      case .date:
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
    self.textField.setUp()
  }

  override func tearDown() {
    super.tearDown()
    self.textField.tearDown()
//    self.textField.removeTarget(self, action: #selector(self.textChanged), for: .editingChanged)
//    self.datePicker.removeTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
  }

}
