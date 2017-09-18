//
//  Store.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 14.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import CoreData
import Foundation

class Store {
  static let shared = Store()
  
  var numberOfPlaces: Int {
    let query: NSFetchRequest<CDPlace> = CDPlace.fetchRequest()
    
    return (try? persistentContainer.viewContext.count(for: query)) ?? 0
  }
  
  private init() { }
  
  // MARK: Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "GroverChallenge")
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    
    return container
  }()
  
  // MARK: Core Data Saving support
  func saveContext () {
    let context = persistentContainer.viewContext
    
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  // MARK: Functions
  func importPlaces(_ places: [Place], _ completion: @escaping (Bool) -> Void) {
    persistentContainer.performBackgroundTask { moc in
      let placeIds = places.map { $0.id }
      let placeQuery: NSFetchRequest<CDPlace> = CDPlace.fetchRequest()
      
      placeQuery.predicate = NSPredicate(format: "id IN %@", placeIds)
      placeQuery.propertiesToFetch = [
        "id"
      ]
      
      let locationQuery: NSFetchRequest<CDLocation> = CDLocation.fetchRequest()
      
      locationQuery.fetchLimit = 1
      
      do {
        let existingPlaceIds = try moc.fetch(placeQuery).map { $0.id! }
        let newPlaces = places.filter { !existingPlaceIds.contains($0.id) }
        
        for newPlace in newPlaces {
          let cdPlace = CDPlace(context: moc)
          
          cdPlace.populateWithPlace(newPlace)
          
          let locationPredicate = [
            NSPredicate(format: "lat = %f", newPlace.location.lat),
            NSPredicate(format: "long = %f", newPlace.location.long)
          ]
          
          locationQuery.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: locationPredicate)
          
          if let location = try moc.fetch(locationQuery).first {
            location.addToPlace(cdPlace)
          } else {
            let location = CDLocation(context: moc)
            
            location.populateWithLocation(newPlace.location)
            
            location.addToPlace(cdPlace)
          }
        }
        
        try moc.save()
        
        DispatchQueue.main.async {
          completion(true)
        }
      } catch let error as NSError {
        print("Unresolved error \(error), \(error.userInfo)")
        
        DispatchQueue.main.async {
          completion(false)
        }
      }
    }
  }
}
