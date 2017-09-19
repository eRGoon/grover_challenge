//
//  Configuration.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 18.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import Foundation

class Configuration {
  static let `default` = Configuration()
  
  var apiBaseUrl: String {
    return "https://maps.googleapis.com"
  }
  var apiKey: String {
    return "AIzaSyCzuD8Y8G2aijHOKIiGYTdsFL9myXQ-NA4"
  }
  
  private init() { }
}
