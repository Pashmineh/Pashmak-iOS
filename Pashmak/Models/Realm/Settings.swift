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
  private static let settingsConfig = Realm.Configuration(fileURL: try! Path.inLibary("settings.realm"),  encryptionKey: "242DC31B-D4F9-4C7A-879E-76328D84D692".sha512, readOnly: false, schemaVersion: 1, objectTypes: [Settings.self])
  
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
    
    try! realm.write {
      realm.add(settings)
    }
    
    return settings
    
  }
  
  func update(pushToken: String) {
    let realm = RealmProvider.SettingsProvider.realm

    try! realm.write {
      self.pushToken = pushToken
    }
    
  }
  
  func update(deviceToken: String) {
    let realm = RealmProvider.SettingsProvider.realm
    
    try! realm.write {
      self.deviceToken = deviceToken
    }
  }
  
  func update(oauthToken: String) {
    let realm = RealmProvider.SettingsProvider.realm
    
    try! realm.write {
      self.oauthToken = oauthToken
    }
  }
  
}
