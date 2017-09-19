//
//  PlaceViewController.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 18.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import CoreData
import UIKit

class PlaceViewController: UIViewController {
  // MARK: Outlets
  
  // MARK: Constants
  private let moc = Store.shared.persistentContainer.newBackgroundContext()
  
  // MARK: Variables
  var placeId: NSManagedObjectID!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
