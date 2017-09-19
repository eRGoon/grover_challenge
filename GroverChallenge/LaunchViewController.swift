//
//  LaunchViewController.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 16.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
  // MARK: Outlets
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    fetchPlaces()
  }
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  }
  
  // MARK: Functions
  private func fetchPlaces() {
    // first get all places from the API
    fetchPlacesRemote { [weak self] success in
      guard success else {
        return
      }
      
      self?.activityIndicator.stopAnimating()
      
      self?.performSegue(withIdentifier: "showPlaces", sender: nil)
    }
  }
  
  private func fetchPlacesRemote(_ completion: @escaping (Bool) -> Void) {
    let location = Location(lat: 52.5009843, long: 13.3649406)
    let radius = 1000
    let parameters: [String:Any] = [
      "type": "art_gallery",
      "language": "en"
    ]
    
    Router.shared.getPlaces(at: location, radius: radius, additionalParameters: parameters) { places, error in
      guard let places = places else {
        if let error = error {
          print(error.localizedDescription)
        }
        
        // API didn't return any data
        // check for local data
        completion(Store.shared.numberOfPlaces > 0)
        
        return
      }
      
      // persist places
      Store.shared.importPlaces(places, completion)
    }
  }
}
