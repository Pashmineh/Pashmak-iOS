//
//  HomeSkeletonCard.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/27/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import IGListKit
import Material
import SkeletonView
import UIKit

class HomeSkeletonItem: ListDiffable {

  let id: String = "FA762235-83DC-45F5-86D7-76320B371D8A"

  func diffIdentifier() -> NSObjectProtocol {
    return id as NSObjectProtocol
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? HomeSkeletonItem else {
      return false
    }
    return object.id == self.id
  }

}

class HomeSkeletonSectionController: ListSectionController {

  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: cellWidth, height: cellHeight)
  }

  var cellWidth: CGFloat {
    return collectionContext?.containerSize.width ?? Screen.width
  }

  var cellHeight: CGFloat {
    return 150.0
  }

  override func numberOfItems() -> Int {
    return Int((collectionContext?.containerSize.height ?? Screen.height) / cellHeight)
  }

  override func cellForItem(at index: Int) -> UICollectionViewCell {
    guard let cell = collectionContext?.dequeueReusableCell(withNibName: "HomeSkeletonCell", bundle: nil, for: self, at: index) as? HomeSkeletonCell else {
      fatalError("Could not dequeue [HomeSkeletonCell]")
    }

    return cell
  }

}
