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
  var date: String = ""
  var refID: String = ""
  var note: String = ""

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

    let item = AddTransactionTextBulletinPage(title: "چقدر پرداخت کردید؟", fieldType: .amount)
    item.actionHandler = { _ in
      let value = item.textField.value
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
    let item = AddTransactionTextBulletinPage(title: "کی پرداخت کرده‌اید؟", fieldType: .date)
    item.actionHandler = { _ in
      let value = item.textField.value
      guard !value.isEmpty else {
        KVNProgress.showError(withStatus: "تاریخ پرداخت را وارد کنید!")
        return
      }
      self.date = value
      item.manager?.displayNextItem()
    }
    item.next = makeRefIDPage()
    return item
  }

  func makeRefIDPage() -> AddTransactionTextBulletinPage {
    let item = AddTransactionTextBulletinPage(title: "شماره پیگیری پرداختی چی بود؟", fieldType: .refID)
    item.actionHandler = { _ in
      var value = item.textField.value
      if value.isEmpty {
        value = "دستی"
      }
      self.refID = value
      item.manager?.displayNextItem()
    }
    item.next = makeNotePage()
    return item
  }

  func makeNotePage() -> AddTransactionTextBulletinPage {
    let item = AddTransactionTextBulletinPage(title: "برای این کارِت چه توضیحی داری؟", fieldType: .note)
    item.actionHandler = { _ in
      let value = item.textField.value
      self.note = value
      _ = item.textField.resignFirstResponder()

      guard let paymentItem = self.generatePaymentItem() else {
        KVNProgress.showError(withStatus: "امکان ثبت این مورد وجود ندارد")
        return
      }
      item.isDismissable = false
      item.manager?.displayActivityIndicator(color: #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1))
      PashmakServer.perform(request: ServerRequest.Transactions.addPayment(payment: paymentItem), validResponseCodes: [200, 201])
        .done { [weak self] (result: ServerData<ServerModels.EmptyServerModel>) in
          guard let self = self else {
            return
          }
          Log.trace("Successfully added payment.")
          item.manager?.dismissBulletin()
        }
        .catch { error in
          var message = "خطا درp عملیات!"
          if case APIError.invalidResponseCode(let statusCode) = error {
            message = Texts.ServerErrors.random + "\n(\(statusCode))"
          }
          KVNProgress.showError(withStatus: message)
          item.manager?.hideActivityIndicator()
          return
        }
    }
    return item
  }

  private func generatePaymentItem() -> ServerModels.Transactions.Item? {

    let account = UserAccount.current
    guard let userID = account?.userID, let userLogin = account?.userLogin else {
      return nil
    }

    let payment = ServerModels.Transactions.Item()
    payment.userLogin = userLogin
    payment.userId = UInt64(userID)
    payment.amount = Int64(self.amount)
//    payment.paymentTime = nil
    payment.reason = .shirini
    return payment
  }

}
