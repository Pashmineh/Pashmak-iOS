//
//  HomeInteractor.swift
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
import Async
import CoreLocation

protocol HomeBusinessLogic {
  func populate(request: Home.Populate.Request)
  func refresh(request: Home.Refresh.Request)
  func signout(request: Home.Signout.Request)
  func checkin(request: Home.Checkin.Request)
//  func updateCheckin(request: Home.UpdateChekinButton.Request)
}

protocol HomeDataStore {

}

class HomeInteractor: NSObject, HomeBusinessLogic, HomeDataStore {

  override init() {
    super.init()

    NotificationCenter.default.addObserver(self, selector: #selector(self.updateReceived), name: Notification.Name.Pashmak.UpdateReceievd, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.checkinUpdate), name: Notification.Name.Pashmak.checkinUpdated, object: nil)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  var presenter: HomePresentationLogic?

  // MARK: iBeacon definistions
  lazy var locationManager: CLLocationManager = {
    let locMan = CLLocationManager()
    locMan.activityType = .automotiveNavigation
    locMan.delegate = self
    return locMan
  }()
  lazy var beacon: CLBeaconRegion = {
    let beacon = CLBeaconRegion(proximityUUID: UUID(uuidString: "00001803-494C-4F47-4943-544543480000")!, major: 10009, minor: 13846, identifier: "KianDigital")
    return beacon
  }()

  var raningTimer: Timer?

  // MARK: Populate

  func populate(request: Home.Populate.Request) {
    Log.trace("Push Token: [\(Settings.current.pushToken)]")
    func sendLoading() {
      let response = Home.Populate.Response.init(state: .loading)
      presenter?.presentPopulate(response: response)
    }

    func sendFailed(_ error: Error) {
      let response = Home.Populate.Response.init(state: .failure(error))
      presenter?.presentPopulate(response: response)
    }

    sendLoading()

    PashmakServer.perform(request: ServerRequest.Home.fetchHome())
      .done { [weak self] (result: ServerData<ServerModels.Home>) in
        guard let self = self else { return }
        let homeData = result.model

        Async.main(after: 2.0) {
          let response = Home.Populate.Response.init(state: .success(homeData))
          self.presenter?.presentPopulate(response: response)
        }
    }
      .catch { (error) in
        sendFailed(error)
    }

  }
  // MARK: Refresh

  @objc
  func updateReceived() {
    let request = Home.Refresh.Request(isInBackground: true)
    self.refresh(request: request)
  }

  func refresh(request: Home.Refresh.Request) {
    let isInBackground = request.isInBackground
    PashmakServer.perform(request: ServerRequest.Home.fetchHome())
      .done { (result: ServerData<ServerModels.Home>) in
        let homeData = result.model

        let response = Home.Refresh.Response(state: .success(homeData), isInBackground: isInBackground)
        self.presenter?.presentRefresh(response: response)

    }
      .catch { (error) in
        let response = Home.Refresh.Response(state: .failure(error), isInBackground: isInBackground)
        self.presenter?.presentRefresh(response: response)
    }

  }

  func signout(request: Home.Signout.Request) {
    Settings.clear()
    (UIApplication.shared.delegate as? AppDelegate)?.stopMonitoring()
    let response = Home.Signout.Response()
    presenter?.presentSignout(response: response)
  }

  // MARK: Chekin

  func checkin(request: Home.Checkin.Request) {
    let notRequired = APIError.invalidPrecondition("ورود امروز خود را ثبت کرده‌اید!")
    func sendChekinLoading(isRanging: Bool) {
      let response = Home.Checkin.Response.init(state: .loading, isRanging: isRanging)
      presenter?.presentCheckin(response: response)
    }

    func sendChekinFailed(_ error: Error, isRanging: Bool) {
      let response = Home.Checkin.Response(state: .failure(error), isRanging: isRanging)
      presenter?.presentCheckin(response: response)
    }

    guard !Checkin.checkedInToday else {
      sendChekinFailed(notRequired, isRanging: false)
      return
    }

    func submitCheckin() {
      Log.trace("Ranged user, lets submit.")
      beaconRanged = nil
      sendChekinLoading(isRanging: false)

      Async.main(after: 1.0) {
        CheckinServices.shared.checkInNow().done { (chekinResponse) in
          guard let checkinResponse = chekinResponse else {
            sendChekinFailed(notRequired, isRanging: false)
            return
          }

          let message = checkinResponse.message ?? ""
          let response = Home.Checkin.Response.init(state: .success(message), isRanging: false)
          self.presenter?.presentCheckin(response: response)
          }
          .catch { (error) in
            sendChekinFailed(error, isRanging: false)
        }
      }

    }

    sendChekinLoading(isRanging: true)

    let startedRanging = startRanging { [weak self] (ranged) in
      guard let self = self else { return }
      self.stopRanging()
      guard ranged else {
        let error = APIError.invalidParameters("Range")
        sendChekinFailed(error, isRanging: true)
        return
      }
      submitCheckin()
    }

    guard startedRanging else {
      let error = APIError.invalidParameters("StartedRanging")
      sendChekinFailed(error, isRanging: true)
      return
    }

  }

  @objc
  private func checkinUpdate() {
    let needsCheckin = !Checkin.checkedInToday
    let response = Home.UpdateChekinButton.Response.init(needsChekin: needsCheckin)
    presenter?.presentCheckinUpdate(response: response)
  }

  private var beaconRanged: ((Bool) -> Void)?

  private func startRanging(rangedHandler: @escaping (Bool) -> Void) -> Bool {
    guard [CLAuthorizationStatus.authorizedAlways, CLAuthorizationStatus.authorizedWhenInUse].contains(CLLocationManager.authorizationStatus()) else {
      Log.trace("user doesn't allow location monitoring. Cannt proceed with location.")
      return false
    }
    Log.trace("Starting to range for beacons!")
    beaconRanged = rangedHandler
    raningTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false, block: { (_) in
      Async.main {
        self.stopRanging()
        self.beaconRanged?(false)
      }

    })

    iBeacon.Beacons.forEach { locationManager.startMonitoring(for: $0); locationManager.startRangingBeacons(in: $0) }
    return true
  }

  private func stopRanging() {
    raningTimer?.invalidate()
    raningTimer = nil
    iBeacon.Beacons.forEach { locationManager.stopRangingBeacons(in: $0) }
  }

}

extension HomeInteractor: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
    Log.trace("Failed to range beacon: [\(region.identifier)] because:\n\(error.localizedDescription)")
  }

  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    Log.trace("beacons ranged: \(beacons)")
    let beaconIDs = iBeacon.Beacons.map { $0.proximityUUID }
    beacons.forEach {
      guard beaconIDs.contains($0.proximityUUID) else {
        Log.trace("Unknown beacon found in ranging: [\($0)]")
        return
      }

      guard $0.proximity != .unknown else {
        Log.trace("Could not determine proximity for beacon [\($0.proximityUUID)]")
        return
      }
      Async.main {
        self.beaconRanged?(true)
      }

    }
  }

}
