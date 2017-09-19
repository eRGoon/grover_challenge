//
//  Router.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 14.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import Foundation
import UIKit

class Router {
  static let shared = Router()
  
  private let session = URLSession(configuration: .default)
  
  private init() { }
  
  func getPlaces(at location: Location, radius: Int = 500, additionalParameters: [String:Any]? = nil, _ completion: @escaping ([Place]?, Error?) -> Void) {
    var query = additionalParameters ?? [:]
    
    query["location"] = "\(location.lat),\(location.long)"
    query["radius"] = radius
    query["key"] = Configuration.default.apiKey
    
    let route = Configuration.default.apiBaseUrl.appending(Path.places.route)
    
    guard var urlComponents = URLComponents(string: route) else {
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
  
  func getPlaceBy(id placeId: String, _ completion: @escaping (Place?, Error?) -> Void) {
    let query: [String:Any] = [
      "place_id": placeId,
      "key": Configuration.default.apiKey
    ]
    
    let route = Configuration.default.apiBaseUrl.appending(Path.place.route)
    
    guard var urlComponents = URLComponents(string: route) else {
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
            guard let json = try (JSONSerialization.jsonObject(with: data) as? JSON)?["result"] as? JSON else {
              completion(nil, JSONError.jsonMalformed)
              
              return
            }
            
            let place = Place(json: json)
            
            completion(place, nil)
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
  
  func getPlacePhotoBy(id photoId: String, width: Int = 1600, _ completion: @escaping (UIImage?, Error?) -> Void) {
    let query: [String:Any] = [
      "photoreference": photoId,
      "maxwidth": width,
      "key": Configuration.default.apiKey
    ]
    
    let route = Configuration.default.apiBaseUrl.appending(Path.photo.route)
    
    guard var urlComponents = URLComponents(string: route) else {
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
          let image = UIImage(data: data)
          
          completion(image, nil)
        } else {
          completion(nil, nil)
        }
      }
    }
    
    task.resume()
  }
  
  private enum Path {
    case places
    case place
    case photo
    
    var route: String {
      switch self {
      case .places:
        return "/maps/api/place/nearbysearch/json"
      case .place:
        return "/maps/api/place/details/json"
      case .photo:
        return "/maps/api/place/photo"
      }
    }
  }
}
