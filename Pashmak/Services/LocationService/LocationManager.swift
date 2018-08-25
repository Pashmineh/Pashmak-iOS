//
//  LocationManager.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
/*
 
 import CoreLocation
 import UserNotifications
 
 class ViewController: UIViewController {
 
 @IBOutlet weak var rssiLabel: UILabel!
 let locationManager = CLLocationManager()
 let beacon: CLBeaconRegion = {
 let b = CLBeaconRegion(proximityUUID: UUID(uuidString: "00001803-494C-4F47-4943-544543480000")!, major: 10009, minor: 13846, identifier: "Kian")
 return b
 }()
 
 override func viewDidLoad() {
 super.viewDidLoad()
 rssiLabel.text = ""
 //    prepareLocationManager()
 //    startMonitoringBeacon()
 //
 
 listMonitoredRegions()
 }
 
 private func stopMonitoring() {
 }
 
 private func listMonitoredRegions() {
 
 for m in locationManager.monitoredRegions {
 print("\(m.identifier)")
 }
 }
 
 private func prepareLocationManager() {
 locationManager.requestAlwaysAuthorization()
 locationManager.delegate = self
 }
 
 private func startMonitoringBeacon() {
 locationManager.startMonitoring(for: beacon)
 locationManager.startRangingBeacons(in: beacon)
 }
 
 }
 
 extension ViewController: CLLocationManagerDelegate {
 
 
 func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
 print("Did fail to monitor for beacon.\n\(error.localizedDescription)")
 }
 
 func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
 print("Did dail to start monitoring.\n\(error.localizedDescription)")
 }
 
 func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
 guard !beacons.isEmpty else {
 print("No beacon has been ranged.")
 return
 }
 
 for b in beacons {
 
 print("[\(b.proximityUUID.uuidString)] in \(b.proximity.rawValue) with accuracy: \(b.accuracy) - RSSI: [\(b.rssi)]")
 
 UIView.transition(with: self.rssiLabel, duration: 0.25, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
 self.rssiLabel.text = b.proximity.descript
 }) { (_) in
 
 }
 }
 }
 
 func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
 guard region is CLBeaconRegion else { return }
 
 }
 
 }
 
 extension CLProximity {
 var descript: String {
 
 switch self {
 case .unknown:
 return "unknown"
 case .far:
 return "far"
 case .immediate:
 return "immediate"
 case .near:
 return "near"
 }
 
 }
 }
 

 */
