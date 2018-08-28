//
//  RealmProvider.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/22/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
import RealmSwift

class RealmProvider {
  let configuration: Realm.Configuration

  internal init(config: Realm.Configuration) {
    self.configuration = config
  }

  var realm: Realm {
    do {
      return try Realm(configuration: configuration)
    } catch {
      fatalError(error.localizedDescription)
    }

  }

}

/// All realm objects must extend this class
class RealmObjects { }
