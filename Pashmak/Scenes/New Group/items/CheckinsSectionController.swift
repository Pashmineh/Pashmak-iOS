//
//  CheckinsSectionController.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import IGListKit
import Material

class CheckinsListSectionController: ListSectionController {
  var item: ServerModels.Checkin.ListItem?

  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: cellWidth, height: cellHeight)
  }

  var cellWidth: CGFloat {
    return collectionContext?.containerSize.width ?? Screen.width
  }

  var cellHeight: CGFloat {
    return 70.0
  }

  override func cellForItem(at index: Int) -> UICollectionViewCell {
    guard let cell = collectionContext?.dequeueReusableCell(withNibName: "CheckinsItemCell", bundle: nil, for: self, at: index) as? CheckinsItemCell else {
      fatalError("Could not dequeue [CheckinsItemCell]")
    }

    cell.item = self.item
    return cell
  }

  override func didUpdate(to object: Any) {
    guard let object = object as? ServerModels.Checkin.ListItem else {
       return
    }

    self.item = object
  }

}
