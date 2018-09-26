//
//  TransactionSectionControllers.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/26/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import IGListKit
import Material

class TransactionItemSectionController: ListSectionController {

  var item: ServerModels.Transactions.Item?

  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: cellWidth, height: cellHeight)
  }

  var cellWidth: CGFloat {
    return collectionContext?.containerSize.width ?? Screen.width
  }

  var cellHeight: CGFloat {
    return 96.0
  }

  override func cellForItem(at index: Int) -> UICollectionViewCell {
    guard let cell = collectionContext?.dequeueReusableCell(withNibName: "TransactionItemCell", bundle: nil, for: self, at: index) as? TransactionItemCell else {
      fatalError("Could not dequeue cell for [TransactionItemCell]")
    }
    cell.item = self.item
    return cell
  }

  override func didUpdate(to object: Any) {
    guard let object = object as? ServerModels.Transactions.Item else {
      return
    }

    self.item = object
  }
}
