//
//  FetchState.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

enum FetchState<T, E> {
  case loading
  case success(T)
  case failure(E)
}
