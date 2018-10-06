//
//  Checkins.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/28/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftDate

// swiftlint:disable sorted_first_last

extension RealmProvider {
  private static let checkinsConfig: Realm.Configuration = {
    do {
      let path = try Path.inLibary("checkins.realm")
      return Realm.Configuration(fileURL: path, encryptionKey: "5EE64BA1-ED4A-4DC4-AC2E-59EA4C469990".sha512, readOnly: false, schemaVersion: 1, objectTypes: [Checkin.self])
    } catch {
      fatalError(error.localizedDescription)
    }

  }()

  static var CheckinsProvider: RealmProvider {
    return RealmProvider(config: RealmProvider.checkinsConfig)
  }

}

@objcMembers
class Checkin: Object {

  enum Property: String {
    case time, id, type, message, userName
  }

  enum CheckinType: String {
    case manual = "MANUAL"
    case iBeacon = "IBEACON"
  }

  dynamic var time = Date()
  dynamic var id: String = UUID().uuidString
  dynamic var type: CheckinType = .manual
  dynamic var message: String = ""
  dynamic var userName: String = ""

  convenience init(model: ServerModels.Checkin.Response) {
    self.init()
    self.time = model.checkinDate ?? Date()
    self.id = model.id ?? UUID().uuidString
    self.message = model.message ?? ""
    self.type = .iBeacon
    self.userName = Settings.current.phoneNumber
  }

}

extension Checkin {

  static var lastCheckin: Checkin? {
    let userName = Settings.current.phoneNumber
    let predicate = NSPredicate(format: "%K == %@", Checkin.Property.userName.rawValue, userName)
    //    Log.trace("Finding last checkin for: [\(userName)]")
    return RealmProvider.CheckinsProvider.realm.objects(Checkin.self).filter(predicate).sorted(byKeyPath: Property.time.rawValue, ascending: false).first
  }

  static func addCheckin(_ checkin: ServerModels.Checkin.Response) {

    let realm = RealmProvider.CheckinsProvider.realm

    do {
      try realm.write {
        realm.add(Checkin(model: checkin))
      }
    } catch {
      Log.warning("Error saving chckin!")
      return
    }

  }

  static var checkedInToday: Bool {
    return lastCheckin?.time.isToday ?? false
  }

}
