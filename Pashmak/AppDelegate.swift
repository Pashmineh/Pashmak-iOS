//
//  AppDelegate.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/20/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import UIKit
import UserNotifications
import Hero
import IQKeyboardManagerSwift
import KVNProgress
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    DispatchQueue.main.async {
//      self.preparePush(application)
      self.prepareHero()
      self.prepareIQKeyboard()
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
  func preparePush(_ application: UIApplication = .shared) {
    let notifCenter = UNUserNotificationCenter.current()
    let userNotificationTypes: UNAuthorizationOptions = [.alert, .badge, .sound]
    
    notifCenter.delegate = self
    notifCenter.requestAuthorization(options: userNotificationTypes) { (granted, error) in
      print("Permission granted: \(granted)")
      
      guard granted else { return }
      
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
    let kvnconf: KVNProgressConfiguration = KVNProgressConfiguration()
    
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
  
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    Settings.current.update(pushToken: token)
    print("Token: [\(token)]")
    
  }
  
}


/*
extension AppDelegate: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedAlways else {
      return
    }
    
    startMonitoring()
    
  }
  
  /*
   func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
   guard let b = beacons.filter({ (be) -> Bool in
   be.proximityUUID.uuidString == "00001803-494C-4F47-4943-544543480000"
   }).first else {
   return
   }
   
   if b.proximity == .near {
   
   }
   
   }
   func sendNotif() {
   guard shouldSendNotif else {
   return
   }
   
   shouldSendNotif = false
   print("Sending notif")
   let content = UNMutableNotificationContent()
   content.title = "پشمک"
   content.body = "به کیان دیجیال خوش اومدید!"
   
   let request = UNNotificationRequest(identifier: "Checkin", content: content, trigger: nil)
   UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
   }*/
  
  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    print("Entered region: \(region.identifier)")
    guard "00001803-494C-4F47-4943-544543480000" == (region as? CLBeaconRegion)?.proximityUUID.uuidString else {
      return
    }
    
    let content = UNMutableNotificationContent()
    content.title = "پشمک"
    content.body = "به کیان دیجیال خوش اومدید!"
    
    let request = UNNotificationRequest(identifier: "Checkin", content: content, trigger: nil)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
  }
}

*/
