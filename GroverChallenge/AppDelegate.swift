//
//  AppDelegate.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 14.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    return true
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    Store.shared.saveContext()
  }

  func applicationWillTerminate(_ application: UIApplication) {
    Store.shared.saveContext()
  }
}

