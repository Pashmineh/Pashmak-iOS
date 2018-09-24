//
//  PollsViewController.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 9/17/18.
//  Copyright (c) 2018 Mohammad Porooshani. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Async
import Hero
import IGListKit
import KVNProgress
import Material
import UIKit

protocol PollsDisplayLogic: AnyObject {

  func displayPopluateLoading(viewModel: Polls.Populate.ViewModel.Loading)
  func displayPopluateFailed(viewModel: Polls.Populate.ViewModel.Failed)
  func displayPopluateSucces(viewModel: Polls.Populate.ViewModel.Success)

  func displayVoteLoading(viewModel: Polls.Vote.ViewModel.Loading)
  func displayVoteFailed(viewModel: Polls.Vote.ViewModel.Failed)
  func displayVoteSuccess(viewModel: Polls.Vote.ViewModel.Success)

}

class PollsViewController: UIViewController {
  var interactor: PollsBusinessLogic?
  var router: (NSObjectProtocol & PollsRoutingLogic & PollsDataPassing)?
  var displayedItems: [ListDiffable] = []

  // MARK: Object lifecycle

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  // MARK: Setup

  private func setup() {
    let viewController = self
    let interactor = PollsInteractor()
    let presenter = PollsPresenter()
    let router = PollsRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }

  // MARK: Routing

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }

  // MARK: View lifecycle

  let updater = ListAdapterUpdater()
  lazy var adapter: ListAdapter = {
    let adapter = ListAdapter(updater: self.updater, viewController: self, workingRangeSize: 5)
    return adapter
  }()

  lazy var refreshControl: UIRefreshControl = {
    let refCon = UIRefreshControl()
    refCon.addTarget(self, action: #selector(self.populate), for: .valueChanged)
    refCon.tintColor = #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
    return refCon
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if displayedItems.isEmpty {
      populate()
    }
  }

  private func prepareUI() {
    prepareNavBar()
    prepareCollectionView()
  }

  private func prepareNavBar() {
    let navbar = self.navigationItem
    navbar.titleLabel.text = "نظرسنجی"
    navbar.titleLabel.textColor = .white
    navbar.titleLabel.font = UIFont.farsiFont(.bold, size: 16.0)
    self.navigationController?.navigationBar.tintColor = .white
  }

  private func prepareCollectionView() {
    let layout = ListCollectionViewLayout(stickyHeaders: false, scrollDirection: UICollectionView.ScrollDirection.vertical, topContentInset: 0.0, stretchToEdge: false)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    let topOffset: CGFloat = 8.0
    collectionView.backgroundColor = .clear
    collectionView.isScrollEnabled = true
    collectionView.scrollIndicatorInsets.top = topOffset
    collectionView.contentInset.top = topOffset
    //    collectionView.contentInset.bottom = 8.0
    collectionView.layer.setShadow(opacity: 0.15, radius: 8.0)
    collectionView.refreshControl = self.refreshControl
    adapter.collectionView = collectionView
    adapter.dataSource = self
    guard let containerView = self.view else {
      return
    }
    containerView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
    collectionView.frame = containerView.bounds
    containerView.addSubview(collectionView)
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }

  @objc
  func populate() {
    let request = Polls.Populate.Request()
    interactor?.populate(request: request)
  }

  func userSelected(_ item: ServerModels.Poll.PollItem.PollAnswer, on poll: ServerModels.Poll.PollItem) {
    let isUnvote = (item.voted == true)
    let request = Polls.Vote.Request(isUnvote: isUnvote, item: item, poll: poll)
    interactor?.vote(request: request)
  }

}

extension PollsViewController: PollsDisplayLogic {
  func displayPopluateLoading(viewModel: Polls.Populate.ViewModel.Loading) {
    if self.displayedItems.isEmpty {
      let items = viewModel.items
      self.displayedItems = items
      self.adapter.performUpdates(animated: true, completion: nil)
    }
  }

  func displayPopluateFailed(viewModel: Polls.Populate.ViewModel.Failed) {
    self.refreshControl.endRefreshing()
    let message = viewModel.message
    KVNProgress.showError(withStatus: message) { [weak self] in
      guard let self = self else {
        return
      }
      self.displayedItems = []
      self.adapter.performUpdates(animated: true, completion: nil)

    }
  }

  func displayPopluateSucces(viewModel: Polls.Populate.ViewModel.Success) {
    self.refreshControl.endRefreshing()
    let items = viewModel.items
    self.displayedItems = items
    self.adapter.performUpdates(animated: true, completion: nil)
  }

  func displayVoteLoading(viewModel: Polls.Vote.ViewModel.Loading) {
    let polls = viewModel.polls
    self.displayedItems = polls
    self.adapter.performUpdates(animated: true, completion: nil)
  }

  func displayVoteFailed(viewModel: Polls.Vote.ViewModel.Failed) {
    let message = viewModel.message
    KVNProgress.showError(withStatus: message)
    let polls = viewModel.polls
    self.displayedItems = polls
    self.adapter.performUpdates(animated: true, completion: nil)
  }

  func displayVoteSuccess(viewModel: Polls.Vote.ViewModel.Success) {
    let polls = viewModel.polls
    self.displayedItems = polls
    self.adapter.performUpdates(animated: true, completion: nil)
  }

}

extension PollsViewController: ListAdapterDataSource {

  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return self.displayedItems
  }

  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    switch object {
    case is ServerModels.Poll.PollItem:
      return PollItemSectionConttroller()
    default:
      fatalError("Unknown object for section controller: [\(object)]")
    }
  }

  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }

}
