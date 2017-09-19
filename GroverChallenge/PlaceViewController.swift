//
//  PlaceViewController.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 18.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import CoreData
import MapKit
import UIKit

class PlaceViewController: UIViewController {
  // MARK: Outlets
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var vicinityLabel: UILabel!
  
  // MARK: Constants
  private let moc = Store.shared.persistentContainer.newBackgroundContext()
  
  // MARK: Variables
  var placeId: NSManagedObjectID!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    fetchPlaceLocal()
  }
  
  // MARK: Functions
  func fetchPlaceLocal() {
    let query: NSFetchRequest<CDPlace> = CDPlace.fetchRequest()
    
    query.predicate = NSPredicate(format: "SELF = %@", placeId)
    query.fetchLimit = 1
    
    do {
      if let place = try moc.fetch(query).first {
        renderPlace(place)
      }
    } catch { }
  }
  
  func fetchPhotoRemote(id photoId: String) {
    Router.shared.getPlacePhotoBy(id: photoId) { [weak self] image, _ in
      self?.imageView.image = image
    }
  }
  
  func renderPlace(_ place: CDPlace) {
    nameLabel.text = place.name
    vicinityLabel.text = place.vicinity
    
    let annotation = MKPointAnnotation()
    let coordinate = CLLocationCoordinate2D(latitude: place.location!.lat, longitude: place.location!.long)
    let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    annotation.coordinate = coordinate
    
    mapView.region = region
    mapView.addAnnotation(annotation)
    
    if let photo = (place.photos?.allObjects as? [CDPhoto])?.first {
      fetchPhotoRemote(id: photo.reference!)
    }
  }
}
