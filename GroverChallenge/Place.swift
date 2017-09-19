//
//  Place.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 14.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import Foundation

class Place {
  var id: String
  var placeId: String
  var location: Location
  var name: String
  var vicinity: String?
  var photos: [String] = []
  
  init?(json: JSON) {
    guard
      let id = json["id"] as? String,
      let placeId = json["place_id"] as? String,
      let location = (json["geometry"] as? JSON)?["location"] as? JSON,
      let lat = location["lat"] as? Double,
      let long = location["lng"] as? Double,
      let name = json["name"] as? String else {
        return nil
    }
    
    self.id = id
    self.placeId = placeId
    self.name = name
    self.location = Location(lat: lat, long: long)
    self.vicinity = json["vicinity"] as? String
    
    if let photosJSON = json["photos"] as? [JSON] {
      for photoJSON in photosJSON {
        if let reference = photoJSON["photo_reference"] as? String {
          photos.append(reference)
        }
      }
    }
  }
}
