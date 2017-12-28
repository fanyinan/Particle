//
//  Circle.swift
//  Particle-Quartz2D
//
//  Created by fanyinan on 2017/3/6.
//  Copyright © 2017年 fyn. All rights reserved.
//

import GLKit

class DotsRender {

  private var dotEffect: DotEffect
  private var coordinateConverter: CoordinateConverter

  private var vertexBuffer = GLuint()
  private var vertexArray = GLuint()
  private var vertice: [Point] = []
  
  init(coordinateConverter: CoordinateConverter) {
    
    self.dotEffect = DotEffect(vertexShaderName: "DotVertexShader", fragmentShaderName: "DotFragmentShader")

    self.coordinateConverter = coordinateConverter
    
  }
  
  func render() {

    dotEffect.prepare()
    
    glBindVertexArray(vertexArray)
    glDrawArrays(GLenum(GL_POINTS), 0, GLsizei(vertice.count))
    glBindVertexArray(0)

    glDeleteBuffers(1, &vertexBuffer)
    glDeleteVertexArrays(1, &vertexArray)
  }
  
  func generateVertice(with dots: [Dot]) {
    
    vertice.removeAll()
    
    for dot in dots {
      vertice.append(Point(position: dot.center, pointSize: dot.radius * 2 * UIScreen.main.scale, coordinateConverter: coordinateConverter))
    }
    
    setVertexBuffer()

  }
  
  private func setVertexBuffer() {
    
    glGenVertexArrays(1, &vertexArray)
    glBindVertexArray(vertexArray)
    
    glGenBuffers(1, &vertexBuffer)
    glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
    glBufferData(GLenum(GL_ARRAY_BUFFER), vertice.size, vertice, GLenum(GL_STATIC_DRAW))
    
    glEnableVertexAttribArray(dotEffect.position)
    glEnableVertexAttribArray(dotEffect.pointSize)
    
    glVertexAttribPointer(dotEffect.position, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Point>.size), nil)
    glVertexAttribPointer(dotEffect.pointSize, 1, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Point>.size), bufferOffset(3 * MemoryLayout<GLfloat>.size))
    
    glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
    glBindVertexArray(0)
    
  }
  
  private func bufferOffset(_ offset :Int) -> UnsafeRawPointer {
    return UnsafeRawPointer(bitPattern: offset)!
  }
}
