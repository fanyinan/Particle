//
//  ParticleGLKView.swift
//  Particle-Quartz2D
//
//  Created by fanyinan on 2017/3/6.
//  Copyright © 2017年 fyn. All rights reserved.
//

import GLKit

class ParticleView: GLKView {

  private var config: ParticleConfig
  private lazy var displayLink: CADisplayLink = self.initDisplayLink()
  private(set) var particleController: ParticleController!
  var viewUpdate: ((CADisplayLink) -> Void)?
  var dotsRender: DotsRender!
  var linesRender: LinesRender!
  
  init(config: ParticleConfig, frame: CGRect) {
    self.config = config
    self.particleController = ParticleController(config: config)
    super.init(frame: frame)
    
    let context = EAGLContext(api: .openGLES3)!
    self.context = context
    EAGLContext.setCurrent(context)
    
    self.delegate = self
    
    dotsRender = DotsRender(coordinateConverter: CoordinateConverter(viewSize: frame.size))
    linesRender = LinesRender(coordinateConverter: CoordinateConverter(viewSize: frame.size))
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func didMoveToSuperview() {
    displayLink.isPaused = false
  }
  
  func stop() {
    
    displayLink.invalidate()
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    let location = touches.first!.location(in: self)
    particleController.addBarrier(at: location)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    let location = touches.first!.location(in: self)
    particleController.moveBarrier(to: location)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    particleController.removeBarrier()
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    particleController.removeBarrier()
  }
  
  func updateLoop(_ displayLink: CADisplayLink) {
    
    particleController.update(with: frame.size)
    
    viewUpdate?(displayLink)

    dotsRender.generateVertice(with: particleController.dots)
    linesRender.generateVertice(with: particleController.lines)
    
    display()
    
  }
  
  private func initDisplayLink() -> CADisplayLink {
    
    let displayLink = CADisplayLink(target: self, selector: #selector(ParticleView.updateLoop(_:)))
    displayLink.add(to: RunLoop.main, forMode: .commonModes)
    
    return displayLink
    
  }
}

extension ParticleView: GLKViewDelegate {
  
  func glkView(_ view: GLKView, drawIn rect: CGRect) {
    
    glClearColor(1, 0, 0, 1)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    glEnable(GLenum(GL_BLEND))
    glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
    
    dotsRender.render()
    linesRender.render()
  }
}
