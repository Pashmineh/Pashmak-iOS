//
//  TransactionItemCell.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/26/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Async
import Material
import SkeletonView
import UIKit

class TransactionItemCell: UICollectionViewCell {

  var item: ServerModels.Transactions.Item? {
    didSet {
      update()
    }
  }

  @IBOutlet private weak var card: PulseView!
  @IBOutlet private weak var iconContainer: UIView!
  @IBOutlet private weak var iconImageView: UIImageView!
  @IBOutlet private weak var typeLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var amountLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    prepareUI()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.card.stopPashmakSkeleton()
    self.iconContainer.stopPashmakSkeleton()
    self.iconImageView.image = nil
    self.typeLabel.text = ""
    self.dateLabel.text = ""
    self.amountLabel.text = ""
  }

  private func prepareUI() {
    prepareCard()
  }

  private func prepareCard() {
    self.contentView.backgroundColor = .clear
    self.card.layer.cornerRadius = 8.0
    self.card.clipsToBounds = true
    self.iconContainer.layer.cornerRadius = 8.0
    self.iconContainer.clipsToBounds = true
    self.iconImageView.image = nil
    self.typeLabel.text = ""
    self.dateLabel.text = ""
    self.amountLabel.text = ""
  }

  private func update() {

    let item = self.item
    Async.main { [weak self] in
      guard let self = self else {
        return
      }

    guard item?.isLoading != true else {
      self.card.startPashmakSkeleton()
      self.iconContainer.startPashmakSkeleton()
      return
    }

    self.card.stopPashmakSkeleton()
    self.iconContainer.stopPashmakSkeleton()

    var reason: ServerModels.Transactions.Reason = item?.reason ?? .takhir
    if item?.isPenalty == false {
      reason = .payment
    }
    self.typeLabel.text = reason.title
    self.iconContainer.backgroundColor = reason.color
    self.iconImageView.image = reason.icon

    if let amount = item?.amount {
      let amountNumber = NSNumber(value: amount * 10)
      let amountText = Formatters.RialFormatterWithRial.string(from: amountNumber)
      self.amountLabel.text = amountText
    } else {
      self.amountLabel.text = "----"
    }

    self.dateLabel.text = item?.paymentDateString ?? ""
    }

  }
}
