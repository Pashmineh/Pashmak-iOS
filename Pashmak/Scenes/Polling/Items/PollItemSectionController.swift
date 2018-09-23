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

  override init() {
    super.init()
    self.supplementaryViewSource = self
  }

  override func numberOfItems() -> Int {
    return item?.isLoading != true ? item?.answers?.count ?? 0 : 3
  }

  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: cellWidth, height: cellHeight)
  }

  var cellWidth: CGFloat {
    return collectionContext?.containerSize.width ?? Screen.width
  }

  var cellHeight: CGFloat {
    return 80.0
  }

  override func cellForItem(at index: Int) -> UICollectionViewCell {
    guard let cell = collectionContext?.dequeueReusableCell(withNibName: "PollItemCell", bundle: nil, for: self, at: index) as? PollItemCell else {
      fatalError("Could nto dequeue [PollItemCell]")
    }
    if item?.isLoading == true {
      cell.isLoading = true
      cell.item = nil
    } else {
      let answer = item?.answers?[index]
      cell.item = answer
      cell.isLoading = false
    }

    return cell
  }

  override func didUpdate(to object: Any) {
    guard let object = object as? ServerModels.Poll.PollItem else {
      return
    }

    self.item = object
  }

  override func didSelectItem(at index: Int) {
    guard let poll = self.item, let item = poll.answers?[index], poll.isLoading != true, item.isSubmitting != true else {
      Log.warning("Could not find poll item or item is loading!")
      return
    }

    (viewController as? PollsViewController)?.userSelected(item, on: poll)

  }

}

extension PollItemSectionConttroller: ListSupplementaryViewSource {

  func supportedElementKinds() -> [String] {
    return [UICollectionView.elementKindSectionHeader, UICollectionView.elementKindSectionFooter]
  }

  func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
    switch elementKind {
    case UICollectionView.elementKindSectionHeader:

      let width = self.cellWidth
      let hPadding: CGFloat = 10.0 + 10.0 + 16.0 + 8 + 24.0 + 12.0
      let maxWidth = width - hPadding
      let question = item?.question ?? ""
      let questionHeight = question.size(with: UIFont.farsiFont(.regular, size: 16.0), in: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)).height
      let height = max(50.0, (questionHeight + 8.0 + 16.0))
      return CGSize(width: width, height: height)
    case UICollectionView.elementKindSectionFooter:
      return CGSize(width: cellWidth, height: 72.0)
    default:
      fatalError("Unknown element kind for size: [\(elementKind)]")
    }
  }

  func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
    switch elementKind {
    case UICollectionView.elementKindSectionHeader:

      guard let header = collectionContext?.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, nibName: "PollHeaderCell", bundle: nil, at: index) as? PollHeaderCell else {
        fatalError("Coould not deque header cell!")
      }
      let question = item?.question ?? ""
      header.isLoading = item?.isLoading ?? false
      header.question = question
      return header

    case UICollectionView.elementKindSectionFooter:
      guard let footer = collectionContext?.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, nibName: "PollFooterCell", bundle: nil, at: index) as? PollFooterCell else {
        fatalError("Could not dequee [PollFooterCell]")
      }
      footer.pollItem = self.item
      return footer
    default:
      fatalError("Unknown element kind for view: [\(elementKind)]")
    }
  }

}
