//
//  File.swift
//  Particle-Quartz2D
//
//  Created by fanyinan on 2017/3/6.
//  Copyright © 2017年 fyn. All rights reserved.
//

import GLKit
import CoreGraphics

struct Point {
  
  var position: (x: GLfloat, y: GLfloat, z: GLfloat)
  var pointSize: GLfloat
  //  var color: (r: GLfloat, g: GLfloat, b: GLfloat, a: GLfloat)
  
  init(position: CGPoint, pointSize: CGFloat, coordinateConverter: CoordinateConverter) {
    self.position = (x: coordinateConverter.convertToGLX(from: position.x), y: coordinateConverter.convertToGLY(from: position.y), z: 0)
    self.pointSize = GLfloat(pointSize)
  }
}
