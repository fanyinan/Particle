//
//  Line.swift
//  Particle-Quartz2D
//
//  Created by fanyinan on 2017/3/3.
//  Copyright © 2017年 fyn. All rights reserved.
//

import UIKit

class Line {
  
  private var color: UIColor = UIColor.white
  
  private(set) var colorWithAlpha: UIColor = UIColor.white
  private(set) var alpha: CGFloat = 0
  
  var start: CGPoint = CGPoint.zero
  var end: CGPoint = CGPoint.zero
  var enable = true
  var maxLength: CGFloat = 0
  var lineAlphaFactor: CGFloat = 1
  
  func calculateColor() {
    
    let distance = start.distance(to: end)
    
    alpha = (1 - distance / maxLength) * lineAlphaFactor
    
  }
}
