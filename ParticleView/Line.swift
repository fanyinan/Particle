//
//  Line.swift
//  Particle-Quartz2D
//
//  Created by 范祎楠 on 2017/3/3.
//  Copyright © 2017年 fyn. All rights reserved.
//

import UIKit

class Line {
  
  static var colorPool: [Int: UIColor] = [:]
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
    
    let alpha_hex = Int(alpha * 255)
    
//    if let color = Line.colorPool[alpha_hex] {
//      colorWithAlpha = color
//    } else {
//      colorWithAlpha = color.withAlphaComponent(CGFloat(alpha_hex) / 255)
//      Line.colorPool[alpha_hex] = colorWithAlpha
//    }
    
  }
}
