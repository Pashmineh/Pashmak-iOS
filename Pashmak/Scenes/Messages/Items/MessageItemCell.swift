//
//  MessageItemCell.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/16/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Material
import SkeletonView
import UIKit

private let kDateFormatter = DateFormatter.farsiDateFormatter(with: "YYYY/MM/dd | HH:mm")

class MessageItemCell: UICollectionViewCell {

  @IBOutlet private weak var card: PulseView!
  @IBOutlet private weak var messageLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!

  var item: ServerModels.Messages.ListItem? {
    didSet {
      update()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    prepareUI()
  }

  private func prepareUI() {
    prepareCard()
  }

  private func prepareCard() {
    self.card.layer.cornerRadius = 8.0
    self.card.clipsToBounds = true
  }

  private func prepareMessageLabel() {
    self.messageLabel.linesCornerRadius = 5
    self.messageLabel.lastLineFillPercent = 65
  }

  private func update() {

    guard item?.isLoading != true else {
      self.messageLabel.transform = CGAffineTransform(scaleX: -1, y: 1)
      self.card.startPashmakSkeleton()
      return
    }
    self.messageLabel.transform = .identity
    self.card.stopPashmakSkeleton()
    self.messageLabel.text = item?.body
    if let date = item?.sendDate {
      self.dateLabel.text = kDateFormatter.string(from: date)
    } else {
      self.dateLabel.text = item?.sendTime
    }
  }

}
