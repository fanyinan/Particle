//
//  Vertex.swift
//  Particle-Quartz2D
//
//  Created by fanyinan on 2017/3/6.
//  Copyright © 2017年 fyn. All rights reserved.
//

import GLKit
import CoreGraphics

struct Vertex {
  
  var position: (x: GLfloat, y: GLfloat, z: GLfloat)
  var color: (r: GLfloat, g: GLfloat, b: GLfloat, a: GLfloat)
  
  init(position: CGPoint, alpha: CGFloat, coordinateConverter: CoordinateConverter) {
    self.position = (x: coordinateConverter.convertToGLX(from: position.x), y: coordinateConverter.convertToGLY(from: position.y), z: 0)
    self.color = (r: 1, g: 1, b: 1, a: GLfloat(alpha))
  }
}
