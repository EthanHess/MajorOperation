//
//  CircleView.swift
//  MajorOperation
//
//  Created by Ethan Hess on 7/24/18.
//  Copyright © 2018 EthanHess. All rights reserved.
//

import UIKit

protocol CircleViewDelegate : class {
    func circleViewWasTapped()
}

class CircleView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    weak var delegate: CircleViewDelegate?
    
    var circleLayer: CAShapeLayer!
    let π = Double.pi
    var currentAmt: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
   
    }
    
    func configure() {
        
        let circleCenter = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        //let arcWidth: CGFloat = 1
        let startAngle: CGFloat = CGFloat(-(π / 2))
        let endAngle = CGFloat((π * 2))
        
        let lineWidth = (radius / 2) - 1
        let path2 = UIBezierPath(arcCenter: circleCenter,
                                 radius: ((radius/2) - 1) - lineWidth/2,
                                 startAngle: startAngle,
                                 endAngle: endAngle,
                                 clockwise: true)
        circleLayer = CAShapeLayer()
        circleLayer.path = path2.cgPath
        circleLayer.strokeColor = UIColor.orange.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeEnd = currentAmt
        layer.addSublayer(circleLayer)
        
        self.addGestureRecognizer(tapGesture())
    }
    
    @objc fileprivate func tapHandler() {
        self.delegate?.circleViewWasTapped()
    }
    
    fileprivate func tapGesture() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.isUserInteractionEnabled = true
        return gesture
    }
    
    func animateCircle(_ duration: TimeInterval, toAmount: CGFloat) {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = currentAmt
        animation.toValue = toAmount
        
        currentAmt = toAmount
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        if circleLayer != nil {
            circleLayer.strokeEnd = toAmount
            circleLayer.add(animation, forKey: "animateCircle")
        }
        
        shapeLayerConfiguration()
    }
    
    fileprivate func shapeLayerConfiguration() {
        
        let shape = CAShapeLayer()
        shape.bounds = self.bounds
        shape.position = CGPoint(x: self.bounds.width / 2, y: self.bounds.width / 2)
        shape.cornerRadius = bounds.width / 2
        self.layer.addSublayer(shape)
        
        shape.path = UIBezierPath(ovalIn: shape.bounds).cgPath
        
        shape.lineWidth = 4.0
        shape.strokeColor = UIColor.cyan.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        shape.strokeStart = 0
        shape.strokeEnd = 0.5
        
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.toValue = 0.7
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.toValue = 1
        
        let group = CAAnimationGroup()
        group.animations = [start, end]
        group.duration = 1.5
        group.autoreverses = true
        group.repeatCount = HUGE
        shape.add(group, forKey: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
