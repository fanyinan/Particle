//
//  BaseEffect.swift
//  Particle-Quartz2D
//
//  Created by 范祎楠 on 2017/3/6.
//  Copyright © 2017年 fyn. All rights reserved.
//

import GLKit

class BaseEffect {
  
  private var vertexShaderName: String
  private var fragmentShaderName: String
  
  private var programHandle: GLuint!
  
  init(vertexShaderName: String, fragmentShaderName: String) {
 
    self.vertexShaderName = vertexShaderName
    self.fragmentShaderName = fragmentShaderName
    
    compileShader()
  }
  
  func getAttribLocation(from programHandle: GLuint) { }
  
  func prepare() {
    glUseProgram(programHandle)
  }
  
  private func compileShader() {
    
    let vertexShader = compileShader(with: vertexShaderName, shaderType: GLenum(GL_VERTEX_SHADER))
    let fragmentShader = compileShader(with: fragmentShaderName, shaderType: GLenum(GL_FRAGMENT_SHADER))
    
    programHandle = glCreateProgram()
    glAttachShader(programHandle, vertexShader)
    glAttachShader(programHandle, fragmentShader)
    glLinkProgram(programHandle)
    
    var linkSuccess = GLint()
    
    glGetProgramiv(programHandle, GLenum(GL_LINK_STATUS), &linkSuccess)
    
    if linkSuccess == GL_FALSE {
      
      var messageLength: GLsizei = 128
      var message = [GLchar](repeating: 0, count: Int(messageLength))
      
      let bufferSize = GLsizei(Int(messageLength) * MemoryLayout<GLchar>.size)
      
      glGetProgramInfoLog(programHandle, bufferSize, &messageLength, &message)
      
      let messageStr = String(validatingUTF8: message) ?? ""
      
      print(messageStr)
      
      exit(1)
    }
    
    getAttribLocation(from: programHandle)
    
  }
  
  private func compileShader(with shaderName: String, shaderType: GLenum) -> GLuint {
    
    let shaderPath = Bundle.main.path(forResource: shaderName, ofType: "glsl")!
    let shaderStr = try! NSString(contentsOfFile: shaderPath, encoding: String.Encoding.utf8.rawValue)
    var shaderUTF8 = shaderStr.utf8String
    var shaderStrLength = GLsizei(shaderStr.length)
    
    let shaderHandle = glCreateShader(shaderType)
    glShaderSource(shaderHandle, 1, &shaderUTF8, &shaderStrLength)
    glCompileShader(shaderHandle)
    
    var compileSuccess = GLint()
    glGetShaderiv(shaderHandle, GLenum(GL_COMPILE_STATUS), &compileSuccess)
    
    if compileSuccess == GL_FALSE {
      
      var messageLength: GLsizei = 128
      var message = [GLchar](repeating: 0, count: Int(messageLength))
      
      let bufferSize = GLsizei(Int(messageLength) * MemoryLayout<GLchar>.size)
      
      glGetShaderInfoLog(shaderHandle, bufferSize, &messageLength, &message)
      
      let messageStr = String(validatingUTF8: message) ?? ""
      
      print(messageStr)
      
      exit(1)
    }
    
    return shaderHandle
  }
}
