//
//  LineEffect.swift
//  Particle-Quartz2D
//
//  Created by fanyinan on 2017/3/6.
//  Copyright © 2017年 fyn. All rights reserved.
//

import GLKit

class LineEffect: BaseEffect {
  
  var position: GLuint!
  var color: GLuint!
  
  override func getAttribLocation(from programHandle: GLuint) {
    position = GLuint(glGetAttribLocation(programHandle, "Position"))
    color = GLuint(glGetAttribLocation(programHandle, "Color"))

  }
}
