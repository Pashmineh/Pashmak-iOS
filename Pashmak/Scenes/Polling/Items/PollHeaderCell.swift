//
//  PollHeaderCell.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/18/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Material
import SkeletonView
import UIKit

class PollHeaderCell: UICollectionReusableView {

  @IBOutlet private weak var card: UIView!
  @IBOutlet private weak var questionLabel: UILabel!

  var isLoading: Bool = false {
    didSet {
      if isLoading {
        self.questionLabel.transform = CGAffineTransform(scaleX: -1, y: 1).translatedBy(x: 0, y: 8.0)
        self.card.startPashmakSkeleton()

      } else {
        self.card.stopPashmakSkeleton()
        self.questionLabel.transform = .identity
      }

    }
  }

  var question: String = "" {
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
    self.questionLabel.linesCornerRadius = 5
    self.questionLabel.lastLineFillPercent = 65
  }

  private func update() {
    self.questionLabel.text = question
  }

}
