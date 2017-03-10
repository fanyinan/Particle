//
//  LinesRender.swift
//  Particle-Quartz2D
//
//  Created by fanyinan on 2017/3/6.
//  Copyright © 2017年 fyn. All rights reserved.
//

import GLKit

class LinesRender {
  
  private var lineEffect: LineEffect!
  private var coordinateConverter: CoordinateConverter
  
  private var vertexBuffer = GLuint()
  private var vertexArray = GLuint()
  private var vertice: [Vertex] = []
  
  init(coordinateConverter: CoordinateConverter) {
    
    self.lineEffect = LineEffect(vertexShaderName: "LineVertexShader", fragmentShaderName: "LineFragmentShader")
    self.coordinateConverter = coordinateConverter
    
  }
  
  func render() {
    
    lineEffect.prepare()

    glBindVertexArray(vertexArray)
    glLineWidth(3)
    glDrawArrays(GLenum(GL_LINES), 0, GLsizei(vertice.count))
    glBindVertexArray(0)
    
    glDeleteBuffers(1, &vertexBuffer)
    glDeleteVertexArrays(1, &vertexArray)

  }
  
  func generateVertice(with lines: [Line]) {
    
    vertice.removeAll()

    for line in lines {
      
      guard line.enable else { break }
      line.enable = false
      
      vertice.append(Vertex(position: line.start, alpha: line.alpha, coordinateConverter: coordinateConverter))
      vertice.append(Vertex(position: line.end, alpha: line.alpha, coordinateConverter: coordinateConverter))
    }
    
    setVertexBuffer()
  }
  
  private func setVertexBuffer() {
    
    glGenVertexArrays(1, &vertexArray)
    glBindVertexArray(vertexArray)
    
    glGenBuffers(1, &vertexBuffer)
    glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
    glBufferData(GLenum(GL_ARRAY_BUFFER), vertice.size, vertice, GLenum(GL_STATIC_DRAW))
    
    glEnableVertexAttribArray(lineEffect.position)
    glEnableVertexAttribArray(lineEffect.color)
    
    glVertexAttribPointer(lineEffect.position, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.size), nil)
    glVertexAttribPointer(lineEffect.color, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.size), bufferOffset(3 * MemoryLayout<GLfloat>.size))
    
    glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
    glBindVertexArray(0)

  }
  
  func bufferOffset(_ offset :Int) -> UnsafeRawPointer {
    return UnsafeRawPointer(bitPattern: offset)!
  }
}
