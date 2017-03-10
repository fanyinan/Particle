//
//  DotEffect.swift
//  Particle-Quartz2D
//
//  Created by fanyinan on 2017/3/6.
//  Copyright © 2017年 fyn. All rights reserved.
//

import GLKit

class DotEffect: BaseEffect {
  
  var position: GLuint!
  var pointSize: GLuint!
  
  override func getAttribLocation(from programHandle: GLuint) {
    position = GLuint(glGetAttribLocation(programHandle, "Position"))
    pointSize = GLuint(glGetAttribLocation(programHandle, "PointSize"))
  }
}

