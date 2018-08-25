//
//  Regex.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/22/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
import Regex

extension Regex {
  
  struct KD {
    
    static let phoneNumber = Regex("^09\\d{9}$")
    static let nationalID = Regex("^\\d{10}$")
    
  }
  
}
