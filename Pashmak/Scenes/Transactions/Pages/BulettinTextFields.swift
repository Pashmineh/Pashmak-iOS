//
//  BulettinTextFields.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/30/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Material
import UIKit

private let kDateFormatter = DateFormatter.farsiDateFormatter(with: "EEEE dd MMMM YYYY | HH:mm")

class BulletingTextField: TextField {
  var value: String {
    return ""
  }
  var valueChanged: ((String) -> Void)?
  var fieldType: AddTransactionTextBulletinPage.FieldType {
    return .amount
  }

  static func textField(for fieldType: AddTransactionTextBulletinPage.FieldType) -> BulletingTextField {
    switch fieldType {
    case .amount:
      return BulletinAmountTextField(frame: .zero)
    case .date:
      return BulletinDateTextField(frame: .zero)
    }
  }

  func setUp() {
  }

  func tearDown() {
  }

}

extension BulletingTextField {

  func prepareTextField() {

    self.font = UIFont.farsiFont(.regular, size: 16.0)
    self.dividerNormalColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
    self.dividerActiveColor = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)
    self.dividerNormalHeight = 1.0
    self.dividerActiveHeight = 2.0

    self.placeholderLabel.text = fieldType.placeHolder
    self.placeholderLabel.font = UIFont.farsiFont(.light, size: 16.0)
    self.placeholderNormalColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
    self.placeholderLabel.textAlignment = .center
    self.placeholderAnimation = .hidden
    self.keyboardType = fieldType.keyboardType

    self.textAlignment = .center
    self.textColor = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)
    self.tintColor = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)
  }
}

class BulletinAmountTextField: BulletingTextField, TextFieldDelegate {
  override var fieldType: AddTransactionTextBulletinPage.FieldType {
    return .amount
  }

  override var value: String {
    return (self.text ?? "").numerals.digits
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    prepareUI()
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  lazy var rialView: UILabel = {
    let rialView = UILabel()
    rialView.text = "ریال"
    rialView.font = UIFont.farsiFont(.regular, size: 12.0)
    rialView.textAlignment = .left
    rialView.textColor = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)
    rialView.alpha = 0.0
    return rialView
  }()

  private func prepareUI() {
    prepareTextField()

    self.layout(rialView).left(4.0).height(21.0).width(30.0).centerVertically()
  }

  override func setUp() {
    super.setUp()
    self.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
    self.delegate = self
    self.textChanged()
  }

  override func tearDown() {
    self.delegate = nil
    self.removeTarget(self, action: #selector(self.textChanged), for: .editingChanged)
    super.tearDown()
  }

  @objc
  private func textChanged() {
    let isEnabled = !self.value.isEmpty
    UIView.animate(withDuration: 0.2) { [weak self] in
      guard let self = self else {
        return
      }
      self.rialView.alpha = isEnabled ? 1.0 : 0.0
    }
    valueChanged?(self.value)
  }

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
      let textRange = textField.textRange(from: curLoc, to: curLoc)
      textField.selectedTextRange = textRange
    }
    textChanged()
    return false

  }

}

class BulletinDateTextField: BulletingTextField {

  override var fieldType: AddTransactionTextBulletinPage.FieldType {
    return .date
  }

  private lazy var datePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.calendar = Calendar(identifier: .persian)
    datePicker.locale = Locale(identifier: "fa_IR")
    datePicker.datePickerMode = .dateAndTime
    datePicker.maximumDate = Date()

    return datePicker
  }()

  override var value: String {
    return "\(datePicker.date.timeIntervalSince1970 * 10)"
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    prepareUI()
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func prepareUI() {
    prepareTextField()
    self.inputView = datePicker
  }

  override func setUp() {
    super.setUp()
    self.datePicker.addTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
    dateChanged()
  }

  override func tearDown() {
    self.datePicker.removeTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
    super.tearDown()
  }

  @objc
  private func dateChanged() {
    let date = datePicker.date
    let dateString = kDateFormatter.string(from: date)
    self.text = dateString
  }
}
