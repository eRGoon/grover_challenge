//
//  CDLocation+Location.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 18.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import Foundation

extension CDLocation {
  func populateWithLocation(_ location: Location) {
    lat = location.lat
    long = location.long
  }
}
