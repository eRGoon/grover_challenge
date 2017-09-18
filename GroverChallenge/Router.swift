//
//  Router.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 14.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import Foundation

class Router {
  static let shared = Router()
  
  private let session = URLSession(configuration: .default)
  
  private init() { }
  
  func getPlaces(at location: Location, radius: Int = 500, additionalParameters: [String:Any]? = nil, _ completion: @escaping ([Place]?, Error?) -> Void) {
    var query = additionalParameters ?? [:]
    
    query["location"] = "\(location.lat),\(location.long)"
    query["radius"] = radius
    query["key"] = Configuration.default.apiKey
    
    guard var urlComponents = URLComponents(string: Configuration.default.apiBaseUrl) else {
      completion(nil, RouteError.urlMalformed)
      
      return
    }
    
    urlComponents.queryItems = query.map { URLQueryItem(name: $0, value: "\($1)") }
    
    guard let url = urlComponents.url else {
      completion(nil, RouteError.queryMalformed)
      
      return
    }
    
    let task = session.dataTask(with: url) { (data, response, error) in
      DispatchQueue.main.async {
        if let error = error {
          completion(nil, error)
          
          return
        } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
          do {
            guard let json = try (JSONSerialization.jsonObject(with: data) as? JSON)?["results"] as? [JSON] else {
              completion(nil, JSONError.jsonMalformed)
              
              return
            }
            
            var places: [Place] = []
            
            for placeJSON in json {
              if let place = Place(json: placeJSON) {
                places.append(place)
              }
            }
            
            completion(places, nil)
          } catch let error {
            completion(nil, error)
          }
        } else {
          completion(nil, nil)
        }
      }
    }
    
    task.resume()
  }
}
