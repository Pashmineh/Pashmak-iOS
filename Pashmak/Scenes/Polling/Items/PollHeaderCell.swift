//
//  PollHeaderCell.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/18/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Material
import UIKit

class PollHeaderCell: UICollectionReusableView {

  @IBOutlet weak var card: UIView!
  @IBOutlet weak var questionLabel: UILabel!

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
  }

  private func update() {
    self.questionLabel.text = question
  }

}
