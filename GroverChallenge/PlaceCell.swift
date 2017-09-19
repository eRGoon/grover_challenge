//
//  PlaceCell.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 18.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import FSPagerView
import MapKit
import UIKit

class PlaceCell: FSPagerViewCell {
  // MARK: Outlets
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    layer.isOpaque = true
    layer.drawsAsynchronously = true
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    layer.shadowRadius = 12
    layer.shadowOpacity = 0.67
    layer.shadowOffset = .zero
    layer.shadowColor = UIColor.lightText.cgColor
  }
}
