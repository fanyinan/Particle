//
//  CGPoint+extension.swift
//  Particle-Quartz2D
//
//  Created by fanyinan on 2017/3/3.
//  Copyright © 2017年 fyn. All rights reserved.
//

import UIKit

extension CGPoint {
  
  func distance(to point2: CGPoint) -> CGFloat {
    
    let w = abs(self.x - point2.x)
    let h = abs(self.y - point2.y)
    return sqrt(w * w + h * h)
  }
}

