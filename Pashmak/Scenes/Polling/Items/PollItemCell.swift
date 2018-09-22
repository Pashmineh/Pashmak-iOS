//
//  PollItemCell.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/17/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Material
import SkeletonView
import UIKit

class PollItemCell: UICollectionViewCell {

  @IBOutlet private weak var card: UIView!
  @IBOutlet private weak var itemImageView: UIImageView!
  @IBOutlet private weak var itemCard: PulseView!
  @IBOutlet private weak var itemTitleLabel: UILabel!

  var item: ServerModels.Poll.PollItem.PollAnswer? {
    didSet {
      update()
    }
  }

  var isLoading: Bool = false {
    didSet {
      updateLoading()
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

    self.itemCard.clipsToBounds = true
    self.itemCard.layer.cornerRadius = 32
    self.itemCard.layer.borderWidth = 1.0 / Screen.scale
    self.itemCard.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)

    self.itemImageView.layer.cornerRadius = 27.0
    self.itemImageView.layer.borderWidth = 1.0
    self.itemImageView.layer.borderColor = #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
    self.itemImageView.clipsToBounds = true

    self.itemTitleLabel.linesCornerRadius = 5

  }

  private func updateLoading() {
    if isLoading {
      self.itemTitleLabel.transform = CGAffineTransform(scaleX: -1, y: 1)
      self.itemImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
      self.itemCard.startPashmakSkeleton()
    } else {
      self.itemCard.stopPashmakSkeleton()
      self.itemTitleLabel.transform = .identity
      self.itemImageView.transform = .identity
    }
  }

  private func update() {
    self.itemTitleLabel.text = item?.title ?? ""
  }

}
