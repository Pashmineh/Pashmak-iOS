//
//  CheckinsItemCell.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Material
import UIKit

private enum Constants {
  static let ontimeIcon = UIImage(named: "checkinIcon")
  static let delayIcon = UIImage(named: "checkinPenaltyIcon")
}

class CheckinsItemCell: UICollectionViewCell {

  var item: ServerModels.Checkin.ListItem? {
    didSet {
      update()
    }
  }

  @IBOutlet private weak var card: PulseView!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var timeContainerView: UIView!
  @IBOutlet private weak var timeLabel: UILabel!
  @IBOutlet private weak var checkinIcon: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    prepareUI()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.card.stopPashmakSkeleton()
  }

  private func prepareUI() {
    prepareCard()
  }

  private func prepareCard() {
    self.card.clipsToBounds = true
    self.card.layer.cornerRadius = 8.0
    self.dateLabel.linesCornerRadius = 5
    self.timeLabel.linesCornerRadius = 5
  }

  private func update() {

    guard self.item?.isLoading != true else {
      self.card.startPashmakSkeleton()
      return
    }

    self.card.stopSkeletonAnimation()

    self.dateLabel.text = item?.checkinDateString ?? ""
    self.timeLabel.text = item?.checkinTimeString ?? "--:--"

    let hasPenalty = item?.hasPenalty == true
    self.timeContainerView.backgroundColor = hasPenalty ? #colorLiteral(red: 1, green: 0, blue: 0.1215686275, alpha: 1) : #colorLiteral(red: 0.3254901961, green: 0.6470588235, blue: 0, alpha: 1)
    self.checkinIcon.image = hasPenalty ? Constants.delayIcon : Constants.ontimeIcon
    
  }

}
