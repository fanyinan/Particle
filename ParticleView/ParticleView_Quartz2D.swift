//
//  ParticleView.swift
//  Particle-Quartz2D
//
//  Created by fanyinan on 2017/3/2.
//  Copyright © 2017年 fyn. All rights reserved.
//

import UIKit

class ParticleView_Quartz: UIView {
  
  private var config: ParticleConfig
  private lazy var displayLink: CADisplayLink = self.initDisplayLink()
  private(set) var particleController: ParticleController!
  var viewUpdate: ((CADisplayLink) -> Void)?
  
  init(config: ParticleConfig) {
    self.config = config
    self.particleController = ParticleController(config: config)
    super.init(frame: CGRect.zero)
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
  
  override func draw(_ rect: CGRect) {
    
    let ctx = UIGraphicsGetCurrentContext()!
    
    ctx.setLineWidth(1)
    
    for dot in particleController.dots {
     
      dot.backgroundColor.set()
      ctx.addArc(center: dot.center, radius: dot.radius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
      ctx.fillPath()
      
    }
    
    for line in particleController.lines {
      
      guard line.enable else { break }
      
      line.enable = false
      line.colorWithAlpha.set()
      ctx.move(to: line.start)
      ctx.addLine(to: line.end)
      ctx.strokePath()
      
    }
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
    
    setNeedsDisplay()

  }
  
  private func initDisplayLink() -> CADisplayLink {
    
    let displayLink = CADisplayLink(target: self, selector: #selector(ParticleView.updateLoop(_:)))
    displayLink.add(to: RunLoop.main, forMode: .commonModes)
    
    return displayLink
    
  }
}
