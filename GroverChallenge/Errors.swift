//
//  Errors.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 14.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import Foundation

enum RouteError: Error {
  case urlMalformed
  case queryMalformed
}

enum JSONError: Error {
  case jsonMalformed
}
