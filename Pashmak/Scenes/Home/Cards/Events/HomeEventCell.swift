//
//  HomeEventCell.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/27/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Material
import UIKit

class HomeEventCell: UICollectionViewCell {

  var event: ServerModels.Home.Event? {
    didSet {
      update()
    }
  }

  @IBOutlet private weak var card: PulseView!
  @IBOutlet private weak var eventNameLabel: UILabel!
  @IBOutlet private weak var addressLabel: UILabel!
  @IBOutlet private weak var mapImageView: UIImageView!
  @IBOutlet private weak var eventTimeLabel: UILabel!
  @IBOutlet private weak var eventDescription: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    prepareUI()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
  }

  private func prepareUI() {

    self.contentView.backgroundColor = .clear
    prepareCard()

  }

  private func prepareCard() {
    self.card.layer.cornerRadius = 10.0
    self.card.setShadow(opacity: 0.15, radius: 6.0, offset: CGSize(width: 0, height: 2.0))
  }

  private func update() {

    guard let event = self.event else {
      return
    }

    var eventName = event.title
    if event.hasPassed {
      eventName = "\(eventName ?? "") - [برگزار شده]"
    }
    self.eventNameLabel.text = eventName
    self.eventDescription.text = event.description
    self.addressLabel.text = event.address?.street
    self.eventTimeLabel.text = event.eventDateTime
    self.card.alpha = event.hasPassed ? 0.5 : 1.0

  }

}
