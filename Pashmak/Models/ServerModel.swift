//
//  ServerModel.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
import Log

extension Encodable {
  var serializedData: Data? {
    do {
      return try JSONEncoder().encode(self)
    } catch {
      Log.error("Could not serializer server model.\n\(error.localizedDescription)")
      return nil
    }
  }
}

protocol ServerModel: Codable {
}

struct ServerData<T: Codable> {
  let httpStatus: Int?
  let model: T
}

enum ServerModels {
  // This is a placeholder enumeration to help manage different type of models
}
