//
//  CGPoint+extension.swift
//  Particle-Quartz2D
//
//  Created by 范祎楠 on 2017/3/3.
//  Copyright © 2017年 fyn. All rights reserved.
//

import UIKit

extension CGPoint {
  
  func distance(to point2: CGPoint) -> CGFloat {
    
    return sqrt(abs(self.x - point2.x) * abs(self.x - point2.x) + abs(self.y - point2.y) * abs(self.y - point2.y))
  }
}

