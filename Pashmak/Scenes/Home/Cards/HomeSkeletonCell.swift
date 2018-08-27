//
//  HomeSkeletonCell.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/27/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import UIKit
import Material
import SkeletonView

class HomeSkeletonCell: UICollectionViewCell {

  @IBOutlet weak var card: UIView!
  @IBOutlet var skeletonviews: [UIView]!
  @IBOutlet weak var skeletonLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    prepareUI()
  }

  private func prepareUI() {
    self.contentView.backgroundColor = .clear
    self.contentView.isSkeletonable = false

    card.layer.cornerRadius = 8.0
    card.depthPreset = .depth3
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
