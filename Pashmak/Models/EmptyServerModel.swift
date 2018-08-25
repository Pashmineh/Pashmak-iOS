//
//  EmptyServerModel.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
extension ServerModels {
  class EmptyServerModel: ServerModel {
  }
  
  class StringServerModel: ServerModel {
    var bodyString: String?
    
    required init(from decoder: Decoder) throws {
    }
    
  }
}
