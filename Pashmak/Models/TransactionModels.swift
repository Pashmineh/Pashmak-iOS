//
//  TransactionsModels.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/26/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import IGListKit
/* Debt
{
  "id": 1751,
  "amount": 5000,
  "paymentTime": "2018-08-21T03:00:00Z",
  "reason": "TAKHIR",
  "userId": 1052,
  "userLogin": "09122214063"
},
*/

/*
{
  "id": 2004,
  "amount": 1000,
  "paymentTime": "2018-08-16T12:03:00Z",
  "reason": "TAKHIR",
  "userId": 1052,
  "userLogin": "09122214063"
},
*/

/*
  "amount": -50000,
  "id": "9CA3D502-88B9-4572-8A96-1341A1489607",
  "message": "جریمه تاخیر ورود در شنبه ۱۴ مهر ۱۳۹۷ ساعت ۱۴:۱۴ به مبلغ \u200f۵۰٬۰۰۰ ﷼  ثبت شد.",
  "reason": "TAKHIR",
  "isValid": true,
  "date": 1538822663.5309041

  */

private let kDateFormatter = DateFormatter.farsiDateFormatter(with: "EEEE، dd MMMM YYYY | HH:mm:ss")

extension ServerModels {
  enum Transactions {

    enum Reason: String, Codable {
      case takhir = "TAKHIR"
      case shirini = "SHIRINI"
      case jalase = "JALASE"
      case payment = "Payment"

      var title: String {
        switch self {
        case .takhir:
          return "تاخیر ورود"
        case .shirini:
          return "شیرینی"
        case .jalase:
          return "تاخیر جلسه"
        case .payment:
          return "پرداخت بدهی"
        }
      }

      var color: UIColor {
        switch self {
        case .takhir:
          return #colorLiteral(red: 1, green: 0, blue: 0.1215686275, alpha: 1)
        case .shirini:
          return #colorLiteral(red: 1, green: 0, blue: 0.1215686275, alpha: 1)
        case .jalase:
          return #colorLiteral(red: 1, green: 0, blue: 0.1215686275, alpha: 1)
        case .payment:
          return #colorLiteral(red: 0.3254901961, green: 0.6470588235, blue: 0, alpha: 1)
        }
      }

      var icon: UIImage? {
        switch self {
        case .takhir:
          return UIImage(named: "transTakhirIcon")
        case .jalase:
          return UIImage(named: "transJalaseIcon")
        case .shirini:
          return UIImage(named: "transShiriniIcon")
        case .payment:
          return UIImage(named: "transPaymentIcon")
        }
      }

    }

    class Item: ServerModel {

      var id: String = UUID().uuidString
      var amount: Int64 = 0
      var dateEpoch: Double?
      var date: Date? { return dateEpoch?.utcDate }
      var reason: Reason?
      var isValid: Bool?
      var message: String?

      var paymentDateString: String {
        let date = self.date ?? Date()
        return kDateFormatter.string(from: date)
      }

      var isLoading: Bool = false
      var isPenalty: Bool = false

      init() {
        self.isLoading = true
        self.isPenalty = [true, false].randomElement() ?? true
      }

      enum CodingKeys: String, CodingKey {
        case id, amount, dateEpoch, reason, isValid, message
      }

    }

  }
}

extension ServerModels.Transactions.Item: ListDiffable {

  func diffIdentifier() -> NSObjectProtocol {
    return self.id as NSObjectProtocol
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? ServerModels.Transactions.Item else {
      return false
    }

    return object.id == self.id
      && object.amount == self.amount
      && object.dateEpoch == self.dateEpoch
      && object.reason == self.reason
      && object.isValid == self.isValid
      && object.message == self.message
      && object.isLoading == self.isLoading
      && object.isPenalty == self.isPenalty
  }

}
