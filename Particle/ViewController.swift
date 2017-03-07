//
//  ViewController.swift
//  Particle-Quartz2D
//
//  Created by 范祎楠 on 2017/3/2.
//  Copyright © 2017年 fyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var config = ParticleConfig()
  lazy var settingView: SettingView = self.createSettingView()
  
  private var lastTime: CFTimeInterval = 0
  private var frameCount = 0
  private var fps = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    
  }
  
  func setupUI() {
    
    let particleView = ParticleView(config: config, frame: view.bounds)
    particleView.backgroundColor = UIColor.red
    particleView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    particleView.viewUpdate = { displayLink in
      
      self.updateFPS(timestamp: displayLink.timestamp)
      let linesCount = particleView.particleController.lines.filter({$0.enable}).count
      self.settingView.update(self.fps, dotsCount: particleView.particleController.dots.count, linesCount: linesCount)
    }
    
    view.addSubview(particleView)
  }
  
  private func updateFPS(timestamp: CFTimeInterval) {
    
    if lastTime == 0 {
      lastTime = timestamp
      return
    }
    
    frameCount += 1
    
    let delta = timestamp - lastTime
    
    guard delta >= 1 else { return }
    
    fps = Int(floor(Double(frameCount) / delta))
    
    lastTime = timestamp
    frameCount = 0
  }
  
  private func createSettingView() -> SettingView {
    
    let settingView = Bundle.main.loadNibNamed("SettingView", owner: self, options: nil)?.first! as! SettingView
    settingView.frame = view.bounds
    settingView.config = config
    view.addSubview(settingView)
    
    return settingView
  }
}

