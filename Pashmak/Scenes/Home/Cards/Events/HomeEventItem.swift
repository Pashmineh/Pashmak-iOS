//
//  HomeEventItem.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/27/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import UIKit
import IGListKit
import Material

class HomeEventSectionController: ListSectionController {

  var event: ServerModels.Home.Event?

  override func numberOfItems() -> Int {
    return 1
  }

  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: cellWidth, height: cellHeight)
  }

  var cellWidth: CGFloat {
    return collectionContext?.containerSize.width ?? Screen.width
  }

  var cellHeight: CGFloat {
    return 230.0
  }

  override func cellForItem(at index: Int) -> UICollectionViewCell {
    guard let cell = collectionContext?.dequeueReusableCell(withNibName: "HomeEventCell", bundle: nil, for: self, at: index) as? HomeEventCell else {
      fatalError()
    }
    cell.event = self.event
    return cell
  }

  override func didUpdate(to object: Any) {
    guard let object = object as? ServerModels.Home.Event else { return }
    self.event = object
  }
}
