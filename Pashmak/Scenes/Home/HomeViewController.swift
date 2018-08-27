//
//  HomeViewController.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/26/18.
//  Copyright (c) 2018 Mohammad Porooshani. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import IGListKit
import Hero
import Material
import Async
import KVNProgress
import Kingfisher
import SkeletonView

protocol HomeDisplayLogic: class {
  func displayPopulateLoading(viewModel: Home.Populate.ViewModel.Loading)
  func displayPopulateFailed(viewModel: Home.Populate.ViewModel.Failed)
  func displayPopulateSuccess(viewModel: Home.Populate.ViewModel.Success)
}

class HomeViewController: UIViewController {
  var interactor: HomeBusinessLogic?
  var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?

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

  let updater = ListAdapterUpdater()
  lazy var adapter: ListAdapter = {
    let adapter = ListAdapter(updater: self.updater, viewController: self, workingRangeSize: 5)
    return adapter
  }()

  private func setup() {
    let viewController = self
    let interactor = HomeInteractor()
    let presenter = HomePresenter()
    let router = HomeRouter()
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

  @IBOutlet weak var topContainer: UIView!
  @IBOutlet weak var collectionContainer: UIView!
  @IBOutlet weak var bottomContainer: UIView!

  @IBOutlet weak var fullnameLabel: UILabel!
  @IBOutlet weak var cycleNameLabel: UILabel!
  @IBOutlet weak var balanceLabel: UILabel!
  @IBOutlet weak var paidLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var avatarBorderView: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.populate()
  }

  private func prepareUI() {
    self.hero.isEnabled = true
    prepareSkeleton()
    prepareAvatar()
    prepareCollectionView()
  }

  private func prepareSkeleton() {
    self.topContainer.isSkeletonable = false
    let cornerRadius = 3

    self.fullnameLabel.isSkeletonable = true
    self.fullnameLabel.linesCornerRadius = cornerRadius

    self.avatarImageView.isSkeletonable = true
    self.avatarBorderView.isSkeletonable = false
    self.cycleNameLabel.isSkeletonable = true
    self.cycleNameLabel.linesCornerRadius = cornerRadius
    self.balanceLabel.isSkeletonable = true
    self.balanceLabel.linesCornerRadius = cornerRadius
    self.paidLabel.isSkeletonable = true
    self.paidLabel.linesCornerRadius = cornerRadius
  }

  private func prepareAvatar() {
    self.avatarImageView.clipsToBounds = true
    self.avatarImageView.layer.cornerRadius = 45.0
    self.avatarImageView.isSkeletonable = true

    self.avatarBorderView.layer.cornerRadius = 49.0
    self.avatarBorderView.clipsToBounds = false
    self.avatarBorderView.layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)
    self.avatarBorderView.layer.borderWidth = 2.0
  }

  private func prepareCollectionView() {
    let layout = ListCollectionViewLayout(stickyHeaders: false, scrollDirection: UICollectionView.ScrollDirection.vertical, topContentInset: 0.0, stretchToEdge: false)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    collectionView.backgroundColor = .clear
    collectionView.isScrollEnabled = true
collectionView.contentInset.top = 8.0
    adapter.collectionView = collectionView
    adapter.dataSource = self
    guard let containerView = self.collectionContainer else { return }
    containerView.backgroundColor = .clear
    collectionView.frame = containerView.bounds
    containerView.addSubview(collectionView)
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }

  func populate() {
    self.view.layoutIfNeeded()
    let request = Home.Populate.Request()
    interactor?.populate(request: request)
  }

  private func updateProfile(_ viewModel: Home.UserProfile) {
    let fullName = viewModel.fullName
    let avatarURL = viewModel.avatarURL
    let cycleName = viewModel.cycleName
    let balance = viewModel.balance
    let paid = viewModel.paid

    self.fullnameLabel.text = fullName

    if let imageURL = URL(string: avatarURL) {
      self.avatarImageView.kf.setImage(with: imageURL)
    }

    self.cycleNameLabel.text = cycleName
    self.balanceLabel.text = balance
    self.paidLabel.text = paid

    self.balanceLabel.textColor = viewModel.balanceColor
    self.avatarBorderView.layer.borderColor = viewModel.balanceColor.cgColor
  }

}

extension HomeViewController: HomeDisplayLogic {

  func displayPopulateLoading(viewModel: Home.Populate.ViewModel.Loading) {
    self.view.isSkeletonable = true
    let skeletonAnimation = SkeletonGradient(baseColor: UIColor.Pashmak.Grey, secondaryColor: UIColor.Pashmak.Timberwolf)

    let items = viewModel.items
    self.displayedItems = items
    self.adapter.performUpdates(animated: true) { (_) in

    }

    self.topContainer.showGradientSkeleton(usingGradient: skeletonAnimation)
    self.topContainer.startSkeletonAnimation()

  }

  func displayPopulateFailed(viewModel: Home.Populate.ViewModel.Failed) {
    let message = viewModel.message
    KVNProgress.showError(withStatus: message)

  }

  func displayPopulateSuccess(viewModel: Home.Populate.ViewModel.Success) {
    let items = viewModel.items
    let profile = viewModel.profile
    self.displayedItems = items
    self.updateProfile(profile)
    self.topContainer.hideSkeleton()
    self.adapter.performUpdates(animated: true, completion: { (_) in
    })
  }

}

extension HomeViewController: ListAdapterDataSource {

  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return self.displayedItems
  }

  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    switch object {
    case is HomeSkeletonItem:
      return HomeSkeletonSectionController()
    case is ServerModels.Home.Event:
      return HomeEventSectionController()
    default:
      fatalError()
    }
  }

  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }

}
