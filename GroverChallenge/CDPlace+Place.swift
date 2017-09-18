//
//  CDPlace+Place.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 16.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import Foundation

extension CDPlace {
  func populateWithPlace(_ place: Place) {
    id = place.id
    placeId = place.placeId
    name = place.name
    vicinity = place.vicinity
  }
}
