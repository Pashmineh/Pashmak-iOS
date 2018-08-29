//
//  LocationManager.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
import CoreLocation

struct iBeacon {

  let proximityID: UUID
  let major: UInt16
  let minor: UInt16
  let identifier: String

  var beaconRegion: CLBeaconRegion {
    return CLBeaconRegion(proximityUUID: proximityID, major: major, minor: minor, identifier: identifier)
  }

  static let KianDigital01 = {
    iBeacon(proximityID: UUID(uuidString: "00001803-494C-4F47-4943-544543480000") ?? UUID(), major: 10009, minor: 13846, identifier: "KianDigital01")
  }()

  static var Beacons: [CLBeaconRegion] {
    return [KianDigital01.beaconRegion]
  }

}
