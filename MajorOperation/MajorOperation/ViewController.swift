//
//  ViewController.swift
//  MajorOperation
//
//  Created by Ethan Hess on 7/21/18.
//  Copyright © 2018 EthanHess. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CircleViewDelegate {
    
    var collection : [UIView] = []
    
    var toggleView : UILabel = {
        let tgv = UILabel()
        return tgv
    }()
    
    var sceneView : SceneKitContainer = {
        let sv = SceneKitContainer()
        return sv
    }()
    
    var originalSKFrame : CGRect! = nil
    var originalToggleFrame : CGRect! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //cool intro animation
        setUpAnimation()
        listen()
    }
    
    fileprivate func listen() {
        NotificationCenter.default.addObserver(self, selector: #selector(animationHandler), name: NSNotification.Name(rawValue: "startLetterAnimation"), object: nil)
    }
    
    fileprivate func setUpAnimation() {
        for index in 0...7 {
            addViewWithIndex(index: index)
        }
    }
    
    fileprivate func animate() {
        
    }
    
    fileprivate func finish() {
        
    }
    
    fileprivate func addViewWithIndex(index: Int) {
        
        let width = self.view.frame.size.width / 4
        
        if index < 4 {
            
            let xCoord = width * CGFloat(index)
            let yCoord = CGFloat(88)
            let startFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
            let endFrame = CGRect(x: xCoord, y: yCoord, width: width, height: width)
            let theView = UIView(frame: startFrame)
            theView.backgroundColor = colorArray()[index]
            theView.alpha = 0.5
            self.view.addSubview(theView)
            collection.append(theView)
            
            UIView.animate(withDuration: 1) {
                theView.frame = endFrame
                theView.alpha = 1
            }
        }
        if index < 8 && index > 3 {
            
            let xCoord = width * CGFloat(index - 4)
            let yCoord = CGFloat(88 + width)
            let startFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
            let endFrame = CGRect(x: xCoord, y: yCoord, width: width, height: width)
            let theView = UIView(frame: startFrame)
            theView.backgroundColor = colorArray()[index]
            theView.alpha = 0.5
            self.view.addSubview(theView)
            collection.append(theView)
            
            UIView.animate(withDuration: 2, animations: {
                theView.frame = endFrame
                theView.alpha = 1
            }) { (finished) in
                self.circleAnimation()
            }
        }
    }
    
    fileprivate func circleAnimation() {
        
        let startColor = UIColor.gray
        let fillColor = UIColor.green
        
        let xStart = self.view.center.x
        let yStart = self.view.center.y - 100 //varies per device
        let xEnd = self.view.frame.size.width / 3
        let yEnd = (self.view.frame.size.height / 2) - 100
        let cStartFrame = CGRect(x: xStart, y: yStart, width: 0, height: 0)
        let cEndFrame = CGRect(x: xEnd, y: yEnd, width: xEnd, height: xEnd)
        let circle = CircleView(frame: cStartFrame)
        collection.append(circle)
        circle.delegate = self
        circle.backgroundColor = startColor
        self.view.addSubview(circle)
        
        UIView.animate(withDuration: 1, animations: {
            circle.layer.cornerRadius = xEnd / 2
            circle.frame = cEndFrame
            circle.configure()
        }) { (finshed) in
            self.draw(fillColor: fillColor, andView: circle)
        }
    }
    
    fileprivate func draw(fillColor: UIColor, andView: CircleView) {
        UIView.animate(withDuration: 1, animations: {
            andView.animateCircle(1, toAmount: 0.9)
        }) { (finished) in
            self.sceneKitFinale()
        }
    }
    
    fileprivate func sceneKitFinale() {
        
        let yCoord = self.view.frame.size.height / 5
        let width = self.view.frame.size.width
        
        sceneView = SceneKitContainer(frame: CGRect(x: 0, y: view.frame.size.height - yCoord, width: width, height: yCoord))
        view.addSubview(sceneView)
        
        collection.append(sceneView)
        
        originalSKFrame = sceneView.frame
        
        let xCoordToggle = self.view.frame.size.width / 5
        
        let toggleFrame = CGRect(x: xCoordToggle * 2, y: sceneView.frame.origin.y - (xCoordToggle / 2), width: xCoordToggle, height: xCoordToggle)
        
        toggleView = UILabel(frame: toggleFrame)
        toggleView.text = "^"
        toggleView.font = UIFont(name: "ArialHebrew", size: 36)
        toggleView.textAlignment = .center
        toggleView.backgroundColor = .darkGray
        toggleView.textColor = .white
        toggleView.layer.borderColor = UIColor.white.cgColor
        toggleView.layer.borderWidth = 1
        toggleView.layer.cornerRadius = xCoordToggle / 2
        toggleView.layer.masksToBounds = true
        
        collection.append(toggleView)
        
        originalToggleFrame = toggleView.frame
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        toggleView.isUserInteractionEnabled = true
        toggleView.addGestureRecognizer(gesture)
        
        view.insertSubview(toggleView, aboveSubview: sceneView)
        
        sceneView.setUpScene()
    }
    
    @objc fileprivate func viewTapped() {
        UIView.animate(withDuration: 0.5, animations: {
            if self.sceneView.frame.origin.y > self.view.frame.size.height / 2 {
                self.sceneView.frame = CGRect(x: 0, y: self.view.frame.size.height / 2, width: self.view.frame.size.width, height: self.view.frame.size.height / 2)
                self.toggleView.frame = CGRect(x: self.toggleView.frame.origin.x, y: (self.view.frame.size.height / 2) - (self.toggleView.frame.size.height / 2), width: self.toggleView.frame.size.width, height: self.toggleView.frame.size.width)
                self.toggleView.text = "v"
                self.sceneView.setUpScene()
            } else {
                self.sceneView.frame = self.originalSKFrame
                self.toggleView.frame = self.originalToggleFrame
                self.toggleView.text = "^"
                self.sceneView.setUpScene()
            }
            
        }) { (finished) in
            
        }
    }
    
    @objc fileprivate func animationHandler() { //For letters
        
        let yCoord = self.view.frame.size.height / 5
        let width = self.view.frame.size.width / 3
        let padding = width / 4
        
        let startFrameH = CGRect(x: -width, y: view.frame.size.height - (yCoord * 2), width: width, height: yCoord)
        let startFrameI = CGRect(x: width * 3, y: view.frame.size.height - (yCoord * 2), width: width, height: yCoord)
        
        let letterH = UILabel(frame: startFrameH)
        let letterI = UILabel(frame: startFrameI)
        
        letterH.text = "H"
        letterH.font = UIFont(name: "ArialHebrew", size: 48.0)
        letterI.text = "I"
        letterI.font = UIFont(name: "ArialHebrew", size: 48.0)
        
        letterH.textColor = UIColor.white
        letterI.textColor = UIColor.cyan
        letterH.textAlignment = .center
        letterI.textAlignment = .center
        
        view.addSubview(letterH)
        view.addSubview(letterI)
        
        collection.append(letterH)
        collection.append(letterI)
        
        let endFrameH = CGRect(x: padding, y: view.frame.size.height - (yCoord * 2), width: width, height: yCoord)
        let endFrameI = CGRect(x: (padding * 3) + width, y: view.frame.size.height - (yCoord * 2), width: width, height: yCoord)
        
        UIView.animate(withDuration: 1, animations: {
            letterH.frame = endFrameH
            letterI.frame = endFrameI
        }) { (finished) in
            
        }
        
    }
    
    fileprivate func colorArray() -> [UIColor] {
        return [UIColor.cyan, UIColor.blue, UIColor.orange, UIColor.darkGray, UIColor.green, UIColor.yellow, UIColor.purple, UIColor.red]
    }
    
    fileprivate func push() {
        let listVC = PhotoListViewController()
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //push()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func circleViewWasTapped() {
        push()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for theView in collection {
            theView.removeFromSuperview()
        }
        
        collection.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

