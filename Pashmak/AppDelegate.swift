//
//  AppDelegate.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/20/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import CoreLocation
import Hero
import IQKeyboardManagerSwift
import KVNProgress
import SkeletonView
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  let locationManager = CLLocationManager()
  let beacons: [CLBeaconRegion] = [iBeacon.KianDigital01.beaconRegion]

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    DispatchQueue.main.async {
//      self.preparePush(application)
      self.prepareUI()
      self.prepareHero()
      self.prepareIQKeyboard()
      self.prepareKVNProgress()
//      self.prepareLocationManager()
    }
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  func applicationSignificantTimeChange(_ application: UIApplication) {
    NotificationCenter.default.post(Notification(name: Notification.Name.Pashmak.checkinUpdated))
  }

  func prepareUI() {
//    SkeletonAppearance.default.multilineHeight = 24.0
    SkeletonAppearance.default.multilineCornerRadius = 5
    UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.farsiFont(.light, size: 10.0)], for: [])
  }

  func preparePush(_ application: UIApplication = .shared) {
    let notifCenter = UNUserNotificationCenter.current()
    let userNotificationTypes: UNAuthorizationOptions = [.alert, .badge, .sound]
    notifCenter.delegate = self
    notifCenter.requestAuthorization(options: userNotificationTypes) { granted, _ in
      print("Permission granted: \(granted)")
      guard granted else {
        return
      }
      DispatchQueue.main.async {
        application.registerForRemoteNotifications()
      }
    }
  }

  private func prepareIQKeyboard() {
    IQKeyboardManager.shared.enable = true
    IQKeyboardManager.shared.enableAutoToolbar = true
    IQKeyboardManager.shared.placeholderFont = UIFont.farsiFont(.light, size: 14.0)
    IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    IQKeyboardManager.shared.keyboardDistanceFromTextField = 24.0
  }
  private func prepareHero() {
    Hero.shared.containerColor = UIColor.Pashmak.Grey
  }
  private func prepareKVNProgress() {
    let kvnconf = KVNProgressConfiguration()
    kvnconf.backgroundFillColor = UIColor.Pashmak.Orange
    kvnconf.backgroundType = .solid
    kvnconf.backgroundTintColor = UIColor.white
    kvnconf.circleStrokeForegroundColor = .white
    kvnconf.statusColor = .white
    kvnconf.errorColor = UIColor.red
    kvnconf.successColor = UIColor.green
    kvnconf.minimumDisplayTime = 1.0
    kvnconf.minimumErrorDisplayTime = 3.0
    kvnconf.statusFont = UIFont.farsiFont(.regular, size: 15.0)
    KVNProgress.setConfiguration(kvnconf)
  }

  func prepareLocationManager() {
    locationManager.activityType = .fitness
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.delegate = self

    switch CLLocationManager.authorizationStatus() {
    case .authorizedAlways:
      startMonitoring()
    case .authorizedWhenInUse:
      locationManager.requestAlwaysAuthorization()
    case .denied:
      Log.trace("Authorization is denied!")
    case .notDetermined:
      locationManager.requestAlwaysAuthorization()
    case .restricted:
      Log.trace("Authorization is restricted!")
    }

  }

  func startMonitoring() {
    locationManager.startMonitoringSignificantLocationChanges()
    for beacon in beacons {
      if locationManager.monitoredRegions.filter({ $0.identifier == beacon.identifier }).isEmpty {
        locationManager.startMonitoring(for: beacon)
        print("Started to monitor for \(beacon.identifier)")
      } else {
        print("already monitoring beacon [\(beacon.identifier)].")
      }
    }
  }

  func stopMonitoring() {
    locationManager.stopMonitoringSignificantLocationChanges()
    beacons.forEach { locationManager.stopMonitoring(for: $0) }
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    Settings.current.update(pushToken: token)
    print("Token: [\(token)]")
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    Log.trace("Got remote norification.\n[\(userInfo)]")

    guard let typeString = userInfo["type"] as? String, let type = UpdatePushModel.UpdateType(rawValue: typeString) else {
      Log.trace("Unknown Background Push type: [\(userInfo["type"] ?? "")]")
      completionHandler(.noData)
      return
    }

    switch type {
    case .poll:
      handleVoteNotif()
    case .checkin:
      handleCheckinNotif()
    case .event:
      handleEventNotif()
    case .home:
      handleHomeNotif()
    case .messages:
      handleMessagesNotif()
    case .profile:
      handleProfileNotif()
    case .transaction:
      handleTransactionNotif()
    }
    completionHandler(.newData)
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

    if notification.request.content.body.isEmpty {
      Log.trace("Empty notification Received.")
      switch notification.request.content.title {
      case "vote", "Vote":
        handleVoteNotif()
      default:
        Log.trace("Unknwon title for empty notification: [\(notification.request.content.title)]")
      }
    } else {
      Log.trace("Notification receivd:\n\(notification.request.content.body)")
      NotificationCenter.default.post(name: NSNotification.Name.Pashmak.UpdateReceievd, object: nil)
      completionHandler([.alert, .badge, .sound])
    }

  }

  private func handleVoteNotif() {
    Log.trace("Vote notification received.")
    NotificationCenter.default.post(name: NSNotification.Name.Pashmak.voteUpdateReceived, object: nil)
  }

  private func handleCheckinNotif() {
    Log.trace("Checkin notification received.")
    NotificationCenter.default.post(name: NSNotification.Name.Pashmak.checkinUpdated, object: nil)
  }

  private func handleEventNotif() {
    Log.trace("Event notification received.")
    NotificationCenter.default.post(name: NSNotification.Name.Pashmak.eventUpdateReceived, object: nil)
  }

  private func handleHomeNotif() {
    Log.trace("Home notification received.")
    NotificationCenter.default.post(name: NSNotification.Name.Pashmak.homeUpdateReceived, object: nil)
  }

  private func handleMessagesNotif() {
    Log.trace("Messages notification received.")
    NotificationCenter.default.post(name: NSNotification.Name.Pashmak.messageUpdateReceived, object: nil)
  }

  private func handleProfileNotif() {
    Log.trace("Profile notification received.")
    NotificationCenter.default.post(name: NSNotification.Name.Pashmak.profileUpdateReceived, object: nil)
  }

  private func handleTransactionNotif() {
    Log.trace("Transaction notification received.")
    NotificationCenter.default.post(name: NSNotification.Name.Pashmak.transactionUpdateReceived, object: nil)
  }

}

extension AppDelegate: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways {
      startMonitoring()
    }
  }

  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {

    guard !Checkin.checkedInToday else {
//      Log.trace("Already checked in today, no need for beacon checkin!")
      return
    }
    print("Entered region: \(region.identifier)")

    let beaconIDs = beacons.map { $0.proximityUUID }
    guard let regionID = (region as? CLBeaconRegion)?.proximityUUID, beaconIDs.contains(regionID) else {
      return
    }

    CheckinServices.shared.checkInNow(type: .iBeacon)
      .done { resp in
        if let resp = resp {

          NotificationCenter.default.post(Notification(name: Notification.Name.Pashmak.checkinUpdated))

          let content = UNMutableNotificationContent()
          content.title = "پشمک"
          content.body = "به کیان دیجیال خوش اومدید!\n\(resp.message ?? "")"
          let request = UNNotificationRequest(identifier: "Checkin", content: content, trigger: nil)
          UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
          Log.trace("Looks like we've already cheked in with server")
        }
      }.catch { error in
        let content = UNMutableNotificationContent()
        content.title = "پشمک"
        content.body = "خطا در ثبت ورود خودکار.\nلطفاً ورودتان را در اپ ثبت کنید."
        let request = UNNotificationRequest(identifier: "Checkin", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        Log.trace("Chekin failed!\n\(error.localizedDescription)")
      }

  }
}
