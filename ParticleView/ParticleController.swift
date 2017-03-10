//
//  DotManager.swift
//  Particle-Quartz2D
//
//  Created by fanyinan on 2017/3/2.
//  Copyright © 2017年 fyn. All rights reserved.
//

import UIKit

class ParticleController {
  
  private var config: ParticleConfig
  private var viewSize = CGSize.zero
  private var bounds: CGRect = CGRect.zero
  private var displaybounds: CGRect = CGRect.zero //在这个范围外的dot消失

  private(set) var dots: [Dot] = []
  private(set) var lines: [Line] = []
  private var barrier: Barrier?
  
  private let maxDistanceToBorderLine: CGFloat = 10
  
  init(config: ParticleConfig) {
    self.config = config
  }
  
  func update(with viewSize: CGSize) {
    
    self.viewSize = viewSize
    self.bounds = CGRect(origin: CGPoint.zero, size: viewSize)
    self.displaybounds = CGRect(x: -maxDistanceToBorderLine, y: -maxDistanceToBorderLine, width: viewSize.width + 2 * maxDistanceToBorderLine, height: viewSize.height + 2 * maxDistanceToBorderLine)
    
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
    
    let (startDirection, endDirection) = randomStartEndDirection()
    let startCenter = getDotCenter(with: startDirection)
    let endCenter = getDotCenter(with: endDirection)

    let speed = CGFloat(arc4random()) / CGFloat(UINT32_MAX) * (config.maxSpeed - config.minSpeed) + config.minSpeed
    
    let dot = Dot(start: startCenter, end: endCenter, radius: radius, speed: max(0.01, speed))
    dots.append(dot)
    
  }
  
  private func getDotCenter(with direction: DotDirection) -> CGPoint {
    
    let positionRatio = CGFloat(arc4random()) / CGFloat(UINT32_MAX)

    //向内移动0.1，防止被移除
    switch direction {
    case .top:
      return CGPoint(x: positionRatio * viewSize.width, y: -maxDistanceToBorderLine + 0.1)
    case .right:
      return CGPoint(x: viewSize.width + maxDistanceToBorderLine - 0.1, y: positionRatio * viewSize.height)
    case .bottom:
      return CGPoint(x: positionRatio * viewSize.width, y: maxDistanceToBorderLine + viewSize.height - 0.1)
    case .left:
      return CGPoint(x: -maxDistanceToBorderLine + 0.1, y: positionRatio * viewSize.height)
    }
  }
  
  private func updateDotCenter() {
    
    dots.forEach { dot in
      dot.move()
      barrier?.repulse(dot: dot)
      
    }
  }
  
  private func removeDotIfNeeded() {
    
    dots = dots.filter({displaybounds.contains($0.center)})
    
  }
  
  private func updateLines() {
    
    //为了避免重复的创建销毁对象带来的性能损耗，这里复用lines中的对象，当不够时再创建新对象
    let storedLineCount = lines.count
    
    var currentLineCount = 0
    
    for i in 0..<dots.count {
      
      let startDot = dots[i]
      
      let startDotDistanceToBorderLine = startDot.distanceToBorderLineIfOutOfView(viewSize: viewSize)
      
      for j in (i + 1)..<dots.count {
      
        let endDot = dots[j]
        
        let distance = startDot.center.distance(to: endDot.center)
        
        guard distance <= config.lineMaxLength else { continue }
        
        var line: Line!
        
        if currentLineCount < storedLineCount {
          
          line = lines[currentLineCount]

        } else {
          
          line = Line()
          lines.append(line)

        }
        
        //避免当dot消失和出现的时候，line会突然出现，使其有一个alpha渐变的效果
        var lineAlphaFactor: CGFloat = 1
        var distanceToBorderLine = startDotDistanceToBorderLine
        
        if distanceToBorderLine == nil {
          distanceToBorderLine = endDot.distanceToBorderLineIfOutOfView(viewSize: viewSize)
        }
        
        if let distanceToBorderLine = distanceToBorderLine {
          lineAlphaFactor = 1 - distanceToBorderLine / maxDistanceToBorderLine
        }
        
        line.enable = true
        line.start = startDot.center
        line.end = endDot.center
        line.maxLength = config.lineMaxLength
        line.lineAlphaFactor = lineAlphaFactor
        line.calculateColor()
        
        currentLineCount += 1

      }
    }
  }
  
  //生成两个不同的随机方向
  private func randomStartEndDirection() -> (DotDirection, DotDirection) {
    
    let startDirectionValue = DotDirection(rawValue: arc4random() % 4)!
    
    var endDirectionValue = DotDirection(rawValue: arc4random() % 3 + 1)!
    
    if endDirectionValue == startDirectionValue {
      endDirectionValue = .top
    }
    
    return (startDirectionValue, endDirectionValue)
  }
}
