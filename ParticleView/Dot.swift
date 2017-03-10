//
//  Dot.swift
//  Particle-Quartz2D
//
//  Created by fanyinan on 2017/3/2.
//  Copyright © 2017年 fyn. All rights reserved.
//

import UIKit

enum DotDirection: UInt32 {
  case top = 0
  case right = 1
  case bottom = 2
  case left = 3
}

class Dot {
  
  private(set) var radius: CGFloat
  private var start: CGPoint
  private var end: CGPoint
  private var speed: CGFloat
  private var xSpeed: CGFloat
  private var ySpeed: CGFloat
  
  var center: CGPoint
  var backgroundColor: UIColor = UIColor.white.withAlphaComponent(0.8)

  init(start: CGPoint, end: CGPoint, radius: CGFloat, speed: CGFloat) {
    
    self.start = start
    self.end = end
    self.radius = radius
    self.speed = speed
    self.center = start
    
    let horiOffset = end.x - start.x
    let verOffset = end.y - start.y
    
    if horiOffset == 0 {
      
      xSpeed = 0
      ySpeed = verOffset > 0 ? speed : -speed
      
    } else if verOffset == 0 {
      
      xSpeed = horiOffset > 0 ? speed : -speed
      ySpeed = 0
      
    } else {
      
      let tan_angle = abs(horiOffset / verOffset)
      let sin_angle = sqrt(tan_angle * tan_angle / (tan_angle * tan_angle + 1))
      let cos_angle = sin_angle / tan_angle
      
      xSpeed = sin_angle * (horiOffset > 0 ? speed : -speed)
      ySpeed = cos_angle * (verOffset > 0 ? speed : -speed)
    }
  }
  
  func move() {
    
    center.x += xSpeed
    center.y += ySpeed
    
  }
  
  func distanceToBorderLineIfOutOfView(viewSize: CGSize) -> CGFloat? {
    
    var distanceToBorderLine: CGFloat?
    
    if center.x < 0 || center.x > viewSize.width {
      distanceToBorderLine = abs(center.x - viewSize.width / 2) - viewSize.width / 2
    } else if center.y < 0 || center.y > viewSize.height {
      distanceToBorderLine = abs(center.y - viewSize.height / 2) - viewSize.height / 2
    }
    
    return distanceToBorderLine
  }
}
