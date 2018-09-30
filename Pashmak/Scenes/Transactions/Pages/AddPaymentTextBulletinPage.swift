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

private let kDateFormatter = DateFormatter.farsiDateFormatter(with: "EEEE dd MMMM YYYY | HH:mm")

class AddTransactionTextBulletinPage: AddPaymentBaseItemPage {

  var fieldTitle: String = ""
  var keyboardType: UIKeyboardType = .default
  var value: String {
    return textField.text ?? ""
  }

  private lazy var datePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.calendar = Calendar(identifier: .persian)
    datePicker.locale = Locale(identifier: "fa_IR")
    datePicker.datePickerMode = .dateAndTime
    datePicker.maximumDate = Date()
    datePicker.addTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
    return datePicker
  }()

  private lazy var textField: TextField = {
    let textField = TextField()

    if keyboardType == .twitter {
      textField.inputView = self.datePicker
    } else {
      textField.keyboardType = keyboardType
    }

    textField.font = UIFont.farsiFont(.regular, size: 16.0)

    textField.dividerNormalColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
    textField.dividerActiveColor = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)
    textField.dividerNormalHeight = 1.0
    textField.dividerActiveHeight = 2.0

    textField.placeholderLabel.text = fieldTitle
    textField.placeholderLabel.font = UIFont.farsiFont(.light, size: 16.0)
    textField.placeholderNormalColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
    textField.placeholderLabel.textAlignment = .center
    textField.placeholderAnimation = .hidden

    textField.textAlignment = .center
    textField.textColor = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)
    textField.tintColor = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)
    textField.delegate = self
    textField.semanticContentAttribute = .forceLeftToRight
    textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)

    let rialView = UILabel()
    rialView.text = "ریال"
    rialView.font = UIFont.farsiFont(.regular, size: 12.0)
    rialView.textAlignment = .left
    rialView.textColor = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)

    textField.layout(rialView).left(4.0).height(21.0).width(30.0).centerVertically()
    return textField

  }()

  override init(title: String) {
    super.init(title: title)
  }

  convenience init(title: String, fieldTitle: String, keyboardType: UIKeyboardType) {
    self.init(title: title, actionColor: #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1), actionTitle: "ادامه", showCancel: true)
    self.keyboardType = keyboardType
    self.fieldTitle = fieldTitle
    self.presentationHandler = { _ in
      self.textChanged()
    }

  }

  override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
    return [textField]
  }

  override func setUp() {
    super.setUp()
    if keyboardType == .twitter {
      dateChanged()
    } else {
      textChanged()
    }

  }

  override func tearDown() {
    super.tearDown()
    self.textField.removeTarget(self, action: #selector(self.textChanged), for: .editingChanged)
    self.datePicker.removeTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
  }

  @objc
  private func dateChanged() {
    let date = datePicker.date
    let dateString = kDateFormatter.string(from: date)
    self.textField.text = dateString
  }

  @objc
  func textChanged() {
    let isEnabled = !self.value.isEmpty
    self.actionButton?.isEnabled = isEnabled
    self.actionButton?.alpha = isEnabled ? 1.0 : 0.5
  }

  private func formatAmount() {
    guard keyboardType == .asciiCapableNumberPad else {
      return
    }

    let digits = (textField.text ?? "").numerals.digits
    let integer = UInt64(digits) ?? 0
    let number = NSNumber(value: integer)
    var newString = Formatters.RialFormatterWithRial.string(from: number)
    if integer == 0 {
      newString = ""
    }
    textField.text = newString
  }

}

extension AddTransactionTextBulletinPage: UITextFieldDelegate {

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard textField.keyboardType == .asciiCapableNumberPad else {
      return true
    }

    let endOffset = textField.offset(from: textField.selectedTextRange?.end ?? textField.beginningOfDocument, to: textField.endOfDocument)
    let text = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
    let digits = text.numerals.digits
    let integer = UInt64(digits) ?? 0
    if integer > 10_000_000 {
      return false
    }
    let number = NSNumber(value: integer)
    var newString = Formatters.RialFormatter.string(from: number)
    if integer == 0 {
      newString = ""
    }
    textField.text = newString
    let cursorLocation = textField.position(from: textField.endOfDocument, offset: -endOffset)
    if let curLoc = cursorLocation {
      let textRange = textField.textRange(from: curLoc, to: curLoc) //textField.textRangeFromPosition(cL, toPosition: cL)
      Async.main {
        textField.selectedTextRange = textRange
      }
    }
    textChanged()
    return false

  }

}
