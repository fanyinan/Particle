//
//  CGFloat+GLCoordinate.swift
//  Particle-Quartz2D
//
//  Created by 范祎楠 on 2017/3/6.
//  Copyright © 2017年 fyn. All rights reserved.
//

import UIKit
import GLKit

class CoordinateConverter {
  
  private var viewSize: CGSize
  
  init(viewSize: CGSize) {
    self.viewSize = viewSize
  }
  
  func convertToGLWidth(from width: CGFloat) -> GLfloat {
    return GLfloat(width / viewSize.width * 2)
  }
  
  func convertToGLHeight(from height: CGFloat) -> GLfloat {
    return GLfloat(height / viewSize.height * 2)
  }
  
  func convertToGLX(from x: CGFloat) -> GLfloat {
    return convertToGLWidth(from: x) - 1
  }
  
  func convertToGLY(from y: CGFloat) -> GLfloat {
    return 1 - convertToGLHeight(from: y)
  }
}
