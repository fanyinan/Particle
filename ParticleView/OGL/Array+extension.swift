//
//  Array+extension.swift
//  Particle-Quartz2D
//
//  Created by 范祎楠 on 2017/3/6.
//  Copyright © 2017年 fyn. All rights reserved.
//

import GLKit

extension Array {
  var size: GLsizeiptr { return count * MemoryLayout<Element>.size}
}
