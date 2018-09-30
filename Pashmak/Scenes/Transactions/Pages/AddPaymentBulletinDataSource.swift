//
//  AddPaymentBulletinDataSource.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/29/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import BLTNBoard
import KVNProgress

typealias BulletinAction = (BLTNPageItem) -> Void

struct ButtonDescriptor {
  let title: String
  let image: UIImage?
  let action: BulletinAction?
}

class AddPaymentBaseItemPage: BLTNPageItem {
  override init(title: String) {
    super.init(title: title)
    appearance.titleTextColor = #colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1)

    let fontDescriptor = UIFont.farsiFont(.regular, size: 18.0).fontDescriptor
    appearance.titleFontDescriptor = fontDescriptor
    appearance.titleFontSize = 18.0
    requiresCloseButton = false
    actionButtonTitle = "لغو"
    actionHandler = { _ in
      self.manager?.dismissBulletin(animated: true)
    }
    appearance.actionButtonColor = #colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1)
    appearance.actionButtonTitleColor = .white
    appearance.buttonFontDescriptor = UIFont.farsiFont(.light, size: 16.0).fontDescriptor
  }

  convenience init(title: String, actionColor: UIColor, actionTitle: String, showCancel: Bool) {
    self.init(title: title)

    appearance.actionButtonColor = actionColor

    if showCancel {
      actionButtonTitle = "ادامه"
      appearance.alternativeButtonTitleColor = #colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1)
      self.alternativeButtonTitle = "بازگشت"
      alternativeHandler = { item in
        item.manager?.popItem()
      }
    }

  }
}

class AddPaymentBulletinDataSource {

  enum PaymentType {
    case shirini, checkout, charge
  }

  var selectedType: PaymentType?
  var amount: UInt64 = 0

  func makeTypeSelection() -> AddTransactionTypeSelectionPage {

    func goNext(type: PaymentType, page: BLTNPageItem) {
      self.selectedType = type
      page.manager?.displayNextItem()
    }

    let shirini = ButtonDescriptor(title: "پرداخت شیرینی", image: UIImage(named: "transactionAddShirini")) { bulletin in
      goNext(type: .shirini, page: bulletin)
    }
    let checkout = ButtonDescriptor(title: "تسویه حساب", image: UIImage(named: "transactionAddCheckout")) { bulletin in
      goNext(type: .checkout, page: bulletin)
    }
    let charge = ButtonDescriptor(title: "شارژ حساب", image: UIImage(named: "transactionAddCharge")) { bulletin in
      goNext(type: .charge, page: bulletin)
    }

    let item = AddTransactionTypeSelectionPage(title: "ثبت پرداخت", buttons: [shirini, checkout, charge])
    item.next = makeAmountPage()
    return item

  }

  func makeAmountPage() -> AddTransactionTextBulletinPage {

    let item = AddTransactionTextBulletinPage(title: "چقدر پرداخت کردید؟", fieldTitle: "مبلغ (ریال)", keyboardType: .asciiCapableNumberPad)
    item.actionHandler = { _ in
      let value = item.value
      guard !value.isEmpty else {
        KVNProgress.showError(withStatus: "ابتدا مبلغ را وارد کنید")
        return
      }
      self.amount = UInt64(value) ?? 0
      item.manager?.displayNextItem()
    }
    item.next = makeDatePage()
    return item
  }

  func makeDatePage() -> AddTransactionTextBulletinPage {
    let item = AddTransactionTextBulletinPage(title: "کی پرداخت کرده‌اید؟", fieldTitle: "تاریخ پرداخت", keyboardType: .twitter)
    return item
  }

}
