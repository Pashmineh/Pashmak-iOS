//
//  MessageItemSectionController.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/16/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import IGListKit
import Material

private let kFont = UIFont.farsiFont(.regular, size: 15.0)

class MessageItemSectionController: ListSectionController {
  var item: ServerModels.Messages.ListItem?

  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: cellWidth, height: cellHeight)
  }

  var cellWidth: CGFloat {
    return collectionContext?.containerSize.width ?? Screen.width
  }

  var cellHeight: CGFloat {
    if item?.isLoading == true {
      return 130.0
    }

    let text = item?.body ?? ""
    let maxWidth = cellWidth - (16 + 16 + 8 + 24)
    let maxSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
    let textHeight = text.size(with: kFont, in: maxSize).height.rounded(.up)
        return max(100, (8 + 4 + 18 + 4 + 8 + 8) + max (32.0, textHeight))

  }

  override func cellForItem(at index: Int) -> UICollectionViewCell {
    guard let cell = collectionContext?.dequeueReusableCell(withNibName: "MessageItemCell", bundle: nil, for: self, at: index) as? MessageItemCell else {
      fatalError("Could not dequeue [MessageItemCell]")
    }
    cell.item = self.item
    return cell
  }

  override func didUpdate(to object: Any) {
    guard let object = object as? ServerModels.Messages.ListItem else {
      return
    }

    self.item = object
  }

}
