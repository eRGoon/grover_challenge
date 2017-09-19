//
//  PlacesViewController.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 18.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import CoreData
import FSPagerView
import MapKit
import UIKit

class PlacesViewController: UIViewController {
  // MARK: Outlets
  @IBOutlet weak var placesView: FSPagerView!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: Constants
  fileprivate let placeCellIdentifier = "placeCell"
  
  // MARK: Variables
  fileprivate var resultsController: NSFetchedResultsController<CDPlace>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let query: NSFetchRequest<CDPlace> = CDPlace.fetchRequest()
    
    query.fetchBatchSize = 10
    query.shouldRefreshRefetchedObjects = true
    query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    resultsController = NSFetchedResultsController(fetchRequest: query, managedObjectContext: Store.shared.persistentContainer.newBackgroundContext(), sectionNameKeyPath: nil, cacheName: nil)
    
    placesView.interitemSpacing = 12
    placesView.itemSize = CGSize(width: UIScreen.main.portraitWidth * 2 / 3, height: UIScreen.main.portraitWidth * 1 / 2)
    placesView.transformer = FSPagerViewTransformer(type: .coverFlow)
    placesView.register(UINib(nibName: "PlaceCell", bundle: nil), forCellWithReuseIdentifier: placeCellIdentifier)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    do {
      try resultsController?.performFetch()
      
      placesView.reloadData()
    } catch {}
  }
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }
    
    switch identifier {
    case "showPlace":
      let placeVC = segue.destination as! PlaceViewController
      
      placeVC.placeId = sender as! NSManagedObjectID
      
    default:
      break
    }
  }
  
  @IBAction func dismissDetail(_ unwindSegue: UIStoryboardSegue) { }
}

// MARK: FSPagerViewDataSource
extension PlacesViewController: FSPagerViewDataSource {
  func numberOfItems(in pagerView: FSPagerView) -> Int {
    return resultsController?.fetchedObjects?.count ?? 0
  }
  
  func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(withReuseIdentifier: placeCellIdentifier, at: index) as! PlaceCell
    
    guard let place = resultsController?.object(at: IndexPath(item: index, section: 0)) else {
      cell.nameLabel.isHidden = true
      
      return cell
    }
    
    cell.nameLabel.text = place.name
    
    let annotation = MKPointAnnotation()
    let coordinate = CLLocationCoordinate2D(latitude: place.location!.lat, longitude: place.location!.long)
    let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    annotation.coordinate = coordinate
    
    cell.mapView.removeAnnotations(cell.mapView.annotations)
    cell.mapView.region = region
    cell.mapView.addAnnotation(annotation)
    
    return cell
  }
}

extension PlacesViewController: FSPagerViewDelegate {
  func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
    if index != pagerView.currentIndex {
      pagerView.deselectItem(at: index, animated: true)
      pagerView.scrollToItem(at: index, animated: true)
      
      return
    }
    
    guard let place = resultsController?.object(at: IndexPath(item: index, section: 0)) else {
      return
    }
    
    performSegue(withIdentifier: "showPlace", sender: place.objectID)
  }
}
