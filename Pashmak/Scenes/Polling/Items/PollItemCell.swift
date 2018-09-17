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

  @IBOutlet private weak var card: PulseView!
  @IBOutlet private weak var questionLabel: UILabel!

  var item: ServerModels.Poll.PollItem? {
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
    self.questionLabel.linesCornerRadius = 5
    self.questionLabel.lastLineFillPercent = 65
  }

  private func update() {

    if item?.isLoading == true {
      self.questionLabel.transform = CGAffineTransform(scaleX: -1, y: 1)
      self.card.startPashmakSkeleton()
      return
    }

    self.card.stopPashmakSkeleton()
    self.questionLabel.transform = .identity
    self.questionLabel.text = item?.question

  }

}
