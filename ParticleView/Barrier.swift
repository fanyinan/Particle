//
//  Barrier.swift
//  Particle-Quartz2D
//
//  Created by 范祎楠 on 2017/3/4.
//  Copyright © 2017年 fyn. All rights reserved.
//

import UIKit

class Barrier {
  
  private var radius: CGFloat
  
  var center: CGPoint

  init(center: CGPoint, radius: CGFloat) {
    self.center = center
    self.radius = radius
  }
  
  func repulse(dot: Dot) {
    
    let distX = dot.center.x - center.x
    let distY = dot.center.y - center.y

    let distance = sqrt(distX * distX + distY * distY)
    
    guard radius > distance else { return }
    
    let ratio = distance / (distance + (1 - distance / radius) * 50)
    
    let repulsedDistX = distX / ratio
    let repulsedDistY = distY / ratio

    dot.center = CGPoint(x: center.x + repulsedDistX, y: center.y + repulsedDistY)
  }
}
