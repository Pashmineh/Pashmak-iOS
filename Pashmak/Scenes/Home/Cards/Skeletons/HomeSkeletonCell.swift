//
//  HomeSkeletonCell.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/27/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Material
import SkeletonView
import UIKit

class HomeSkeletonCell: UICollectionViewCell {

  @IBOutlet private weak var card: UIView!
  @IBOutlet private var skeletonviews: [UIView]!
  @IBOutlet private weak var skeletonLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    prepareUI()
  }

  private func prepareUI() {
    self.contentView.backgroundColor = .clear
    self.contentView.isSkeletonable = false

    card.layer.cornerRadius = 8.0
    card.setShadow(opacity: 0.15, radius: 6.0)
    card.isSkeletonable = false

    skeletonviews.forEach {
      $0.isSkeletonable = true

    }
    skeletonLabel.isSkeletonable = true
    skeletonLabel.linesCornerRadius = 4
    skeletonLabel.lastLineFillPercent = 70

    let skeletonAnimation = SkeletonGradient(baseColor: UIColor.Pashmak.Grey, secondaryColor: UIColor.Pashmak.Timberwolf)

    self.card.showGradientSkeleton(usingGradient: skeletonAnimation)
    self.card.startSkeletonAnimation()

  }

}
