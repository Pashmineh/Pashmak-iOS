//
//  PollItemCell.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/17/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Async
import Kingfisher
import Material
import SkeletonView
import UIKit

private let kImagePH = UIImage(named: "votePH")

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

  override func prepareForReuse() {
    super.prepareForReuse()
    self.itemCard.alpha = 1.0
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
    self.itemImageView.layer.borderWidth = 1.0 / Screen.scale
    self.itemImageView.layer.borderColor = #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
    self.itemImageView.alpha = 0.75
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

  func update() {

    item?.itemChangedHandler = { [weak self] in
      guard let self = self else {
        return
      }

      self.updateValues()

    }

    updateValues()

    if let imgSrc = item?.imgsrc, let imgURL = URL(string: imgSrc) {
      self.itemImageView.kf.setImage(with: imgURL, placeholder: kImagePH, options: nil, progressBlock: nil, completionHandler: nil)
    } else {
      self.itemImageView.image = kImagePH
    }
    self.itemTitleLabel.text = self.item?.title ?? ""

  }

  private func updateValues() {
    
    if self.item?.isSubmitting == true {
      self.itemCard.alpha = 0.5
    } else {
      self.itemCard.alpha = 1.0
    }

    let isVoted = self.item?.voted == true

    self.itemCard.layer.borderColor = isVoted ? #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
    self.itemCard.layer.borderWidth = isVoted ? 2.0 : 1.0 / Screen.scale
    self.itemImageView.layer.borderColor = isVoted ? #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
    self.itemImageView.layer.borderWidth = isVoted ? 1.0 : 1.0 / Screen.scale
    self.itemImageView.alpha = isVoted ? 1.0 : 0.75
    self.itemTitleLabel.textColor = isVoted ? #colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1) : #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
    self.itemCard.backgroundColor = isVoted ? #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1) : #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)

  }

}
