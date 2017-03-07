//
//  DotManager.swift
//  Particle-Quartz2D
//
//  Created by 范祎楠 on 2017/3/2.
//  Copyright © 2017年 fyn. All rights reserved.
//

import UIKit

class ParticleController {
  
  private var config: ParticleConfig
  private var viewSize = CGSize.zero
  private(set) var dots: [Dot] = []
  private(set) var lines: [Line] = []
  private var barrier: Barrier?
  
  init(config: ParticleConfig) {
    self.config = config
  }
  
  func update(with viewSize: CGSize) {
    
    self.viewSize = viewSize
    
    updateDotCenter()
    addDotIfNeeded()
    removeDotIfNeeded()
    updateLines()
    
  }
  
  func addBarrier(at center: CGPoint) {
    
     barrier = Barrier(center: center, radius: config.repulseRadius)
  }
  
  func removeBarrier() {
    
    barrier = nil
  }
  
  func moveBarrier(to center: CGPoint) {
    
    guard let barrier = barrier else { return }
    
    barrier.center = center
  }
  
  private func addDotIfNeeded() {
    
    let lackDotCount =  config.maxDotCount - dots.count
    
    guard lackDotCount > 0 else { return }
    
    guard arc4random() % 2 == 1 else { return }
    
    let radius = CGFloat(arc4random() % UInt32(config.maxRadius - config.minRadius)) + config.minRadius
    let (startDirection, startCenter) = getRandomDotCenter(with: radius)
    let (_, endCenter) = getRandomDotCenter(with: radius, exceptDiretion: startDirection)

    let speed = CGFloat(arc4random()) / CGFloat(UINT32_MAX) * (config.maxSpeed - config.minSpeed) + config.minSpeed
    
    let dot = Dot(start: startCenter, end: endCenter, radius: radius, speed: max(0.01, speed))
    dots.append(dot)
    
  }
  
  private func getRandomDotCenter(with radius: CGFloat, exceptDiretion: DotDirection? = nil) -> (DotDirection, CGPoint) {
    
    let positionRatio = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
    
    let directionValue = arc4random() % 4
    var direction = DotDirection(rawValue: directionValue)!
    
    if direction == exceptDiretion {
      direction = DotDirection(rawValue: (directionValue + 1) % 4)!
    }
    
    //加0.1是为了时圆点在创建出来的时候，圆点的一部分在view里面，防止检测到不在view中被移除
    switch direction {
    case .top:
      return (direction, CGPoint(x: positionRatio * viewSize.width, y: -radius + 0.1))
    case .right:
      return (direction, CGPoint(x: viewSize.width + radius - 0.1, y: positionRatio * viewSize.height))
    case .bottom:
      return (direction, CGPoint(x: positionRatio * viewSize.width, y: radius + viewSize.height - 0.1))
    case .left:
      return (direction, CGPoint(x: -radius + 0.1, y: positionRatio * viewSize.height))
    }
  }
  
  private func updateDotCenter() {

    dots.forEach { dot in
      dot.move()
      barrier?.repulse(dot: dot)
    }
  }
  
  private func removeDotIfNeeded() {
    
    dots = dots.filter({$0.isDisplay(in: CGRect(origin: CGPoint.zero, size: viewSize))})
    
  }
  
  private func updateLines() {
    
    //为了避免重复的创建销毁对象带来的性能损耗，这里复用lines中的对象，当不够时再创建新对象
    let storedLineCount = lines.count
    
    var currentLineCount = 0
    
    for i in 0..<dots.count {
      
      let startDot = dots[i]
      
      for j in (i + 1)..<dots.count {
      
        let endDot = dots[j]
        
        let distance = startDot.center.distance(to: endDot.center)
        
        guard distance <= config.lineMaxLength else { continue }
        
        if currentLineCount < storedLineCount {
          
          let line = lines[currentLineCount]
          line.enable = true
          line.start = startDot.center
          line.end = endDot.center
          line.maxLength = config.lineMaxLength
          line.calculateColor()

        } else {
          
          lines.append(Line(start: startDot.center, end: endDot.center, maxLength: config.lineMaxLength))

        }
        
        currentLineCount += 1

      }
    }
  }
}
