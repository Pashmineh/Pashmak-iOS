//
//  PollItemSectionController.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/17/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import IGListKit
import Material

class PollItemSectionConttroller: ListSectionController {

  var item: ServerModels.Poll.PollItem?

  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: cellWidth, height: cellHeight)
  }

  var cellWidth: CGFloat {
    return collectionContext?.containerSize.width ?? Screen.width
  }

  var cellHeight: CGFloat {
    return 150.0
  }

  override func cellForItem(at index: Int) -> UICollectionViewCell {
    guard let cell = collectionContext?.dequeueReusableCell(withNibName: "PollItemCell", bundle: nil, for: self, at: index) as? PollItemCell else {
      fatalError("Could nto dequeue [PollItemCell]")
    }
    cell.item = item
    return cell
  }

  override func didUpdate(to object: Any) {
    guard let object = object as? ServerModels.Poll.PollItem else {
      return
    }

    self.item = object
  }

}
