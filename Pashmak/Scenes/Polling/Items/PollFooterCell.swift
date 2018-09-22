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

private enum Constants {

  static let normalAttributes: [NSAttributedString.Key: Any] = {
    let paragStyle = NSMutableParagraphStyle()
    paragStyle.alignment = .right
    paragStyle.baseWritingDirection = .rightToLeft
    return [.font: UIFont.farsiFont(.light, size: 10.0), .foregroundColor: #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1), .paragraphStyle: paragStyle]
  }()

  static let valueAttributes: [NSAttributedString.Key: Any] = {
    let paragStyle = NSMutableParagraphStyle()
    paragStyle.alignment = .right
    paragStyle.baseWritingDirection = .rightToLeft
    return [.font: UIFont.farsiFont(.regular, size: 10.0), .foregroundColor: #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1), .paragraphStyle: paragStyle]
  }()

}

class PollFooterCell: UICollectionReusableView {

  var pollItem: ServerModels.Poll.PollItem? {
    didSet {
      update()
    }
  }

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

    let remainingVotes = pollItem?.remainingVotes ?? 0
    let totalVoted = pollItem?.totalVote ?? 0
    let timeRemaining = 10

    let itemsLeftText = combine(title: "آراء باقی‌مانده شما: ", with: "\(remainingVotes)")
    self.itemsLeftLabel.attributedText = itemsLeftText

    let totalVotesText = combine(title: "آراء اخذ شده: ", with: "\(totalVoted) نفر")
    self.castedVotesLabel.attributedText = totalVotesText

    let timeRemainingText = combine(title: "زمان باقی‌مانده: ", with: "\(timeRemaining) ساعت")
    self.expirationDateLabel.attributedText = timeRemainingText

  }

  private func combine(title: String, with value: String) -> NSAttributedString {

    let result = NSMutableAttributedString(string: title, attributes: Constants.normalAttributes)
    result.append(NSAttributedString(string: value, attributes: Constants.valueAttributes))
    return result

  }

}
