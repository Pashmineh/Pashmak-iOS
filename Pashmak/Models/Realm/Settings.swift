//
//  Settings.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/22/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

//swiftlint:disable first_where
import Foundation
import RealmSwift

extension RealmProvider {
  private static let settingsConfig: Realm.Configuration = {
    do {
      let path = try Path.inLibary("settings.realm")
      return Realm.Configuration(fileURL: path, encryptionKey: "242DC31B-D4F9-4C7A-879E-76328D84D692".sha512, readOnly: false, schemaVersion: 1, objectTypes: [Settings.self, UserAccount.self])
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
    dynamic var lastUpdatedPush: String = ""
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
      updatePushOnServer(token: pushToken)
      do {
        try realm.write {
          self.pushToken = pushToken
        }
      } catch {
        fatalError(error.localizedDescription)
      }

    }

    private func updateLastPushToken(token: String) {
      let realm = RealmProvider.SettingsProvider.realm
      do {
        try realm.write {
          self.lastUpdatedPush = token
        }
      } catch {
        fatalError(error.localizedDescription)
      }
    }

    private func updatePushOnServer(token: String) {
//      guard lastUpdatedPush != token else {
//        Log.trace("Token is already uptodate")
//        return
//      }

      PashmakServer.perform(request: ServerRequest.Authentication.updateToken(token: token), validResponseCodes: [200, 201])
        .done { (result: ServerData<ServerModels.EmptyServerModel>) in
          _ = result.model
          self.updateLastPushToken(token: token)
        }
        .catch { error in
          Log.error("Error sending token update.\n\(error.localizedDescription)")
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

    static func clear() {

      let pushToken = Settings.current.pushToken
      let realm = RealmProvider.SettingsProvider.realm
      do {
        try realm.write {
          realm.delete(realm.objects(Settings.self))
        }
        Settings.current.update(pushToken: pushToken)
      } catch {
        fatalError(error.localizedDescription)
      }

    }

}

@objcMembers
class UserAccount: Object {

  enum Property: String {
    case userID, userLogin, firstName, lastName, email, imageUrl
  }

  dynamic var userID: Int = 0
  dynamic var userLogin: String?
  dynamic var firstName: String?
  dynamic var lastName: String?
  dynamic var email: String?
  dynamic var imageUrl: String?

  convenience init(model: ServerModels.UserAccount) {
    self.init()
    self.userID = Int(model.id)
    self.userLogin = model.login
    self.firstName = model.firstName
    self.lastName = model.lastName
    self.email = model.email
    self.imageUrl = model.imageUrl
  }

  static var current: UserAccount? {
    let realm = RealmProvider.SettingsProvider.realm
     return realm.objects(UserAccount.self).first
  }

  static func update() {
    let realm = RealmProvider.SettingsProvider.realm
    PashmakServer.perform(request: ServerRequest.Account.getAccount())
      .done { (result: ServerData<ServerModels.UserAccount>) in
        let account = result.model
        do {
          try realm.write {
            let predicate = NSPredicate(format: "%K == %d", UserAccount.Property.userID.rawValue, Int(account.id))
            if let realmAccount = realm.objects(UserAccount.self).filter(predicate).first {
              realmAccount.userLogin = account.login
              realmAccount.firstName = account.firstName
              realmAccount.lastName = account.lastName
              realmAccount.imageUrl = account.imageUrl
              Log.trace("Account updated.")
            } else {
              realm.add(UserAccount(model: account))
              Log.trace("Account created.")
            }
          }

        } catch {
          Log.warning("Error updating account.\n\(error.localizedDescription)")
          return
        }

      }
      .catch { error in
        Log.warning("Error updating account.\n\(error.localizedDescription)")
      }
  }

}
