//
//  Extensions.swift
//  GroverChallenge
//
//  Created by Ronny Gerasch on 17.09.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import UIKit

extension UIScreen {
  var width: CGFloat {
    return bounds.size.width
  }
  var height: CGFloat {
    return bounds.size.height
  }
  var portraitWidth: CGFloat {
    return min(width, height)
  }
  var landscapeWidth: CGFloat {
    return max(width, height)
  }
}
