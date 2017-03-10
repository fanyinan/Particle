//
//  ParticleConfig.swift
//  Particle-Quartz2D
//
//  Created by fanyinan on 2017/3/2.
//  Copyright © 2017年 fyn. All rights reserved.
//

import UIKit

class ParticleConfig {
  
  var maxDotCount = 60
  
  var maxRadius: CGFloat = 6
  var minRadius: CGFloat = 3
  
  var maxSpeed: CGFloat = 2
  var minSpeed: CGFloat = 0.2
  
  var color = UIColor.white.withAlphaComponent(0.7)
  
  var lineMaxLength: CGFloat = 100
  
  var repulseRadius: CGFloat = 120

}
