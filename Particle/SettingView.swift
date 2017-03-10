//
//  SettingView.swift
//  Particle-Quartz2D
//
//  Created by fanyinan on 2017/3/5.
//  Copyright © 2017年 fyn. All rights reserved.
//

import UIKit

class SettingItem {
  var name: String
  var range: Range<Float>
  var percentValue: Float
  var showValue: Float { return (range.upperBound - range.lowerBound) * percentValue + range.lowerBound }
  
  init(name: String, range: Range<Float>, showValue: Float) {
    self.name = name
    self.range = range
    self.percentValue = (showValue - range.lowerBound) / (range.upperBound - range.lowerBound)
  }
}

class SettingView: UIView {
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var fpsLabel: UILabel!
  @IBOutlet weak var dotsCountLabel: UILabel!
  @IBOutlet weak var linesCountLabel: UILabel!
  @IBOutlet weak var operationContainerView: UIView!
  
  @IBOutlet weak var widthConstraints: NSLayoutConstraint!
  @IBOutlet weak var heightConstraints: NSLayoutConstraint!
  @IBOutlet weak var topConstraints: NSLayoutConstraint!
  @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
  
  var operationView: UIView!
  var sliders: [UISlider] = []
  var valueLabels: [UILabel] = []

  var config: ParticleConfig! {
    didSet{
      
      dataSource.append(SettingItem(name: "dots count", range: Range(uncheckedBounds: (0, 500)), showValue: Float(config.maxDotCount)))
      dataSource.append(SettingItem(name: "max speed", range: Range(uncheckedBounds: (0.1, 10)), showValue: Float(config.maxSpeed)))
      dataSource.append(SettingItem(name: "min speed", range: Range(uncheckedBounds: (0.1, 10)), showValue: Float(config.minSpeed)))
      dataSource.append(SettingItem(name: "max length", range: Range(uncheckedBounds: (0, 300)), showValue: Float(config.lineMaxLength)))

      initWidget()

    }
  }
  
  var dataSource: [SettingItem] = []
  var minSize: CGSize!
  var maxSize: CGSize!
  
  let maxDotsCountRange = Range(uncheckedBounds: (0, 500))
  let maxSpeedRange = Range(uncheckedBounds: (0.1, 10))
  let minSpeedRange = Range(uncheckedBounds: (0.1, 10))
  let lineMaxLengthRange = Range(uncheckedBounds: (0, 300))
  
  override func awakeFromNib() {
    
    containerView.layer.masksToBounds = true
    containerView.layer.cornerRadius = 5
    
    minSize = CGSize(width: widthConstraints.constant, height: heightConstraints.constant)
    maxSize = CGSize(width: frame.width - leadingConstraints.constant * 2, height: frame.height - topConstraints.constant * 2)
    
    operationView = UIView(frame: CGRect(origin: CGPoint.zero, size: maxSize))
    operationView.alpha = 0
    operationContainerView.addSubview(operationView)
    
  }
  
  func update(_ fps: Int, dotsCount: Int, linesCount: Int) {
    
    self.fpsLabel.text = "fps \(fps)"
    self.dotsCountLabel.text = "dots \(dotsCount)"
    self.linesCountLabel.text = "lines \(linesCount)"
    
  }
  
  @IBAction func onClick() {
    
    var operationViewAlpha: CGFloat = 0
    
    if containerView.frame.size == minSize {
      widthConstraints.constant = maxSize.width
      heightConstraints.constant = maxSize.height
      operationViewAlpha = 1
      
    } else {
      widthConstraints.constant = minSize.width
      heightConstraints.constant = minSize.height
      operationViewAlpha = 0
    }

    UIView.animate(withDuration: 0.2) {
      self.setNeedsLayout()
      self.layoutIfNeeded()
      self.operationView.alpha = operationViewAlpha
    }
  }
  
  @objc private func onSliderChange(_ sender: UISlider) {
    
    guard let index = sliders.index(where: {$0 == sender}) else { return }
    
    let settingItem = dataSource[index]
    dataSource[index].percentValue = sender.value
    
    switch index {
    case 0:
      config.maxDotCount = Int(settingItem.showValue)
      valueLabels[index].text = "\(Int(settingItem.showValue))"

    case 1:
      config.maxSpeed = CGFloat(settingItem.showValue)
      valueLabels[index].text = String(format: "%.1f", settingItem.showValue)

      let minSpeedSettingItem = dataSource[2]
      minSpeedSettingItem.percentValue = min(minSpeedSettingItem.percentValue, settingItem.percentValue)
      sliders[2].value = minSpeedSettingItem.percentValue
      config.minSpeed = CGFloat(minSpeedSettingItem.showValue)
      valueLabels[2].text = String(format: "%.1f", minSpeedSettingItem.showValue)
      
    case 2:
      config.minSpeed = CGFloat(settingItem.showValue)
      valueLabels[index].text = String(format: "%.1f", settingItem.showValue)

      let maxSpeedSettingItem = dataSource[1]
      maxSpeedSettingItem.percentValue = max(maxSpeedSettingItem.percentValue, settingItem.percentValue)
      sliders[1].value = maxSpeedSettingItem.percentValue
      config.minSpeed = CGFloat(maxSpeedSettingItem.showValue)
      valueLabels[1].text = String(format: "%.1f", maxSpeedSettingItem.showValue)
      
    case 3:
      config.lineMaxLength = CGFloat(settingItem.showValue)
      valueLabels[index].text = "\(Int(settingItem.showValue))"

    default:
      break
    }
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    
    let result = super.hitTest(point, with: event)
    
    if containerView.point(inside: containerView.convert(point, from: nil), with: event) {
      return result
    }
    
    return self.superview?.subviews.filter({$0 is ParticleView}).first
  }
  
  private func initWidget() {
    
    let height: CGFloat = 30
    let sliderMargin: CGFloat = 10

    for (index, settingItem) in dataSource.enumerated() {
     
      let containerView = UIView(frame: CGRect(x: 0, y: (height + 20) * CGFloat(index) + 10, width: operationView.frame.width, height: height))
      operationView.addSubview(containerView)
      
      let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: containerView.frame.height))
      nameLabel.font = UIFont.systemFont(ofSize: 14)
      nameLabel.textColor = UIColor.black
      nameLabel.text = settingItem.name
      containerView.addSubview(nameLabel)
      
      let valueLabel = UILabel(frame: CGRect(x: containerView.frame.width - 50, y: 0, width: 50, height: containerView.frame.height))
      valueLabel.font = UIFont.systemFont(ofSize: 14)
      valueLabel.textColor = UIColor.black
      valueLabel.text = "\(settingItem.showValue)"
      containerView.addSubview(valueLabel)
      valueLabels.append(valueLabel)
      
      let sliderWidth = operationView.frame.width - nameLabel.frame.width - valueLabel.frame.width - sliderMargin * 2
      let slider = UISlider(frame: CGRect(x: nameLabel.frame.maxX + sliderMargin, y: 0, width: sliderWidth, height: containerView.frame.height))
      slider.value = settingItem.percentValue
      slider.addTarget(self, action: #selector(SettingView.onSliderChange(_:)), for: .valueChanged)
      containerView.addSubview(slider)
      sliders.append(slider)
    }
  }
}
