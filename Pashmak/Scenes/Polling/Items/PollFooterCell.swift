//
//  PollFooterCell.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/18/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Material
import SkeletonView
import UIKit

class PollFooterCell: UICollectionReusableView {

  @IBOutlet private weak var card: UIView!

  @IBOutlet private weak var itemsLeftLabel: UILabel!
  @IBOutlet private weak var castedVotesLabel: UILabel!
  @IBOutlet private weak var expirationDateLabel: UILabel!

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

  private func update() {
    
  }

}
