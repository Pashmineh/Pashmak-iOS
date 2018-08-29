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
import VisualEffectView
import SnapKit

protocol HomeDisplayLogic: class {
  func displayPopulateLoading(viewModel: Home.Populate.ViewModel.Loading)
  func displayPopulateFailed(viewModel: Home.Populate.ViewModel.Failed)
  func displayPopulateSuccess(viewModel: Home.Populate.ViewModel.Success)

  func displayRefreshFailed(viewModel: Home.Refresh.ViewModel.Failed)
  func displayRefreshSuccess(viewModel: Home.Refresh.ViewModel.Success)

  func displaySignout(viewModel: Home.Signout.ViewModel)

  func displayCheckinLoading(viewModel: Home.Checkin.ViewModel.Loading)
  func displayCheckinFailed(viewModel: Home.Checkin.ViewModel.Failed)
  func displayCheckinSuccess(viewModel: Home.Checkin.ViewModel.Success)
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
  @IBOutlet weak var checkinButton: Material.Button!
  @IBAction func checkinButtonTapped(_ sender: Any) {
    checkin()
  }

  @IBOutlet weak var signoutButton: Material.Button!
  @IBAction func signoutButtonTapped(_ sender: Any) {
    self.signout()
  }

  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = UIColor.Pashmak.Orange
    refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    return refreshControl
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//    self.populate()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.populate()
  }

  private func prepareUI() {
    self.hero.isEnabled = true
    preparePush()
    prepareTopContainer()
    prepareSkeleton()
    prepareAvatar()
    prepareCollectionView()
    prepareCheckinButton()
  }

  private func preparePush() {
//    print("Current Token: [\(Settings.current.pushToken)]")
    (UIApplication.shared.delegate as? AppDelegate)?.preparePush()
  }

  private func prepareTopContainer() {

    let blurView = VisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
    blurView.blurRadius = 5.0
    self.topContainer.insertSubview(blurView, at: 0)
    self.topContainer.layout(blurView).edges()
    self.signoutButton.pulseColor = UIColor.Pashmak.davyGrey
    self.signoutButton.pulseAnimation = .centerRadialBeyondBounds
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
    collectionView.contentInset.top = 140.0
    collectionView.contentInset.bottom = 64.0
    collectionView.refreshControl = self.refreshControl
    adapter.collectionView = collectionView
    adapter.dataSource = self
    guard let containerView = self.collectionContainer else { return }
    containerView.backgroundColor = .clear
    collectionView.frame = containerView.bounds
    containerView.addSubview(collectionView)
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }

  private func prepareCheckinButton() {
    self.checkinButton.layer.cornerRadius = 22.0
    self.checkinButton.pulseColor = UIColor.Pashmak.Grey
    self.checkinButton.transform = CGAffineTransform(translationX: 0, y: 54.0)
    self.checkinButton.alpha = 0.0
  }

  func populate() {
    self.view.layoutIfNeeded()
    let request = Home.Populate.Request()
    interactor?.populate(request: request)
  }

  @objc
  func refresh() {
    let request = Home.Refresh.Request.init(isInBackground: false)
    interactor?.refresh(request: request)
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

  private func signout() {
    let request = Home.Signout.Request()
    interactor?.signout(request: request)
  }

  private func showCheckinButton(isActive: Bool) {

    guard let button = self.checkinButton else { return }
    button.isEnabled = isActive
    button.backgroundColor = isActive ? UIColor.Pashmak.buttonActive : UIColor.Pashmak.Grey
    let title = isActive ? "ثبت ورود" : "ورود امروز خود را ثبت کرده‌اید"
    let color: UIColor = isActive ? UIColor.Pashmak.Grey : UIColor.Pashmak.TextDeactive
    button.setTitle(title, for: [])
    button.setTitleColor(color, for: [])
    UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 6.0, options: [], animations: {
      button.transform = .identity
      button.alpha = 1.0
    }) { (_) in

    }

  }

  private func checkin() {
    let request = Home.Checkin.Request()
    interactor?.checkin(request: request)
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
    let needsCheckin = viewModel.needsCheckIn
    self.displayedItems = items
    self.updateProfile(profile)
    self.topContainer.hideSkeleton()

    self.showCheckinButton(isActive: needsCheckin)
    self.adapter.performUpdates(animated: true, completion: { (_) in
    })
  }

  func displayRefreshFailed(viewModel: Home.Refresh.ViewModel.Failed) {
    let isInBack = viewModel.isInBackground
    self.refreshControl.endRefreshing()

    if !isInBack {
      let message = viewModel.message
      KVNProgress.showError(withStatus: message)
    }

  }

  func displayRefreshSuccess(viewModel: Home.Refresh.ViewModel.Success) {
    self.refreshControl.endRefreshing()
    let profile = viewModel.profile
    self.topContainer.hideSkeleton()
    self.updateProfile(profile)
    let items = viewModel.items
    self.displayedItems = items

    self.adapter.performUpdates(animated: true) { (_) in

    }
  }

  func displaySignout(viewModel: Home.Signout.ViewModel) {
    self.router?.routeToLogin(segue: nil)
  }

  func displayCheckinLoading(viewModel: Home.Checkin.ViewModel.Loading) {
    let message = viewModel.message
    KVNProgress.show(withStatus: message)
  }

  func displayCheckinFailed(viewModel: Home.Checkin.ViewModel.Failed) {
    let message = viewModel.message
    KVNProgress.showError(withStatus: message)
  }

  func displayCheckinSuccess(viewModel: Home.Checkin.ViewModel.Success) {
    let message = viewModel.message

    func updateForCheckin() {
      showCheckinButton(isActive: false)
    }

    if !message.isEmpty {
      KVNProgress.showSuccess(withStatus: message) {
        updateForCheckin()
      }
    } else {
      KVNProgress.dismiss {
        updateForCheckin()
      }
    }
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
