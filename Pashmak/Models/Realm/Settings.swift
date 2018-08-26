//
//  Settings.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/22/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
import RealmSwift

extension RealmProvider {
  private static let settingsConfig: Realm.Configuration = {
    do {
      let path = try Path.inLibary("settings.realm")
      return Realm.Configuration(fileURL: path, encryptionKey: "242DC31B-D4F9-4C7A-879E-76328D84D692".sha512, readOnly: false, schemaVersion: 1, objectTypes: [Settings.self])
    } catch {
      fatalError(error.localizedDescription)
    }

  }()

  static var SettingsProvider: RealmProvider {
    return RealmProvider(config: RealmProvider.settingsConfig)
  }

}

@objcMembers
class Settings: Object {

  enum Property: String {
    case pushToken, deviceToken, oauthToken
  }

  dynamic var pushToken: String = ""
  dynamic var deviceToken: String = ""
  dynamic var oauthToken: String = ""
  dynamic var firstName: String = ""
  dynamic var lastName: String = ""
  dynamic var phoneNumber: String = ""
  dynamic var avatarURL: String = ""

  convenience init(deviceToken: String, pushToken: String, oauthToken: String) {
    self.init()
    self.deviceToken = deviceToken
    self.pushToken = pushToken
    self.oauthToken = oauthToken
  }

  static var current: Settings {
    let realm = RealmProvider.SettingsProvider.realm
    if let settings = realm.objects(Settings.self).first {
      return settings
    }

    let settings = Settings()
    settings.deviceToken = UUID().uuidString
    do {
      try realm.write {
        realm.add(settings)
      }
    } catch {
      fatalError(error.localizedDescription)
    }

    return settings

  }

  var fullName: String {

    var result = ""
    if !firstName.isEmpty {
      result += firstName
    }

    if !lastName.isEmpty {
      result += " \(lastName)"
    }

    return result

  }

  func update(pushToken: String) {
    let realm = RealmProvider.SettingsProvider.realm

    do {
      try realm.write {
        self.pushToken = pushToken
      }
    } catch {
      fatalError(error.localizedDescription)
    }

  }

  func update(deviceToken: String) {
    let realm = RealmProvider.SettingsProvider.realm

    do {
      try realm.write {
        self.deviceToken = deviceToken
      }
    } catch {
      fatalError(error.localizedDescription)
    }

  }

  func update(oauthToken: String) {
    let realm = RealmProvider.SettingsProvider.realm
    do {
      try realm.write {
        self.oauthToken = oauthToken
      }
    } catch {
      fatalError(error.localizedDescription)
    }

  }

  func update(firstName: String, lastName: String) {
    let realm = RealmProvider.SettingsProvider.realm
    do {
      try realm.write {
        self.firstName = firstName
        self.lastName = lastName
      }
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  func update(phoneNumber: String) {
    let realm = RealmProvider.SettingsProvider.realm
    do {
      try realm.write {
        self.phoneNumber = phoneNumber
      }
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  func update(avatarURL: String) {
    let realm = RealmProvider.SettingsProvider.realm
    do {
      try realm.write {
        self.avatarURL = avatarURL
      }
    } catch {
      fatalError(error.localizedDescription)
    }
  }

}
