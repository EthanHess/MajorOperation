//
//  SceneKitContainer.swift
//  MajorOperation
//
//  Created by Ethan Hess on 7/24/18.
//  Copyright © 2018 EthanHess. All rights reserved.
//

import UIKit
import SceneKit

class SceneKitContainer: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //setUpScene()
    }
    
    func setUpScene() {
        
        let scene = SCNScene()
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        //can add animation to camera :)
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 50)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        let scnView = SCNView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.backgroundColor = .darkGray

        self.addSubview(scnView)
        
        animate(scene: scene)
    }
    
    func animate(scene: SCNScene) {
        for index in 0...3 {
            let node = nodes()[index]
            node.geometry?.firstMaterial?.diffuse.contents = colors()[index]
            scene.rootNode.addChildNode(node)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startLetterAnimation"), object: nil, userInfo: nil)
    }
    
    fileprivate func nodes() -> [SCNNode] {
        
        let width = self.frame.size.width / 16
        let sphereDiameter = width - 20
        let sphereGeometry = SCNSphere(radius: CGFloat(sphereDiameter))
     
        let sphereNodeOne = SCNNode(geometry: sphereGeometry)
        let sphereNodeTwo = SCNNode(geometry: sphereGeometry)
        let sphereNodeThree = SCNNode(geometry: sphereGeometry)
        let sphereNodeFour = SCNNode(geometry: sphereGeometry)
        
        sphereNodeOne.position = SCNVector3(10, 0, 0)
        sphereNodeTwo.position = SCNVector3(width - 10, 0, 0)
        sphereNodeThree.position = SCNVector3((width * 2) - 10, 0, 0)
        sphereNodeFour.position = SCNVector3((width * 3) - 10, 0, 0)
    
        return [sphereNodeOne, sphereNodeTwo, sphereNodeThree, sphereNodeThree]
    }
    
    fileprivate func startFrames() -> [CGRect] {
        let width = self.frame.size.width / 4
        let frameOne = CGRect(x: -width, y: 0, width: width, height: width)
        let frameTwo = CGRect(x: -width, y: 0, width: width, height: width)
        let frameThree = CGRect(x: -width, y: 0, width: width, height: width)
        let frameFour = CGRect(x: -width, y: 0, width: width, height: width)
        return [frameOne, frameTwo, frameThree, frameFour]
    }
    
    fileprivate func endFrames() -> [CGRect] {
        let width = self.frame.size.width / 4
        let frameOne = CGRect(x: 0, y: 0, width: width, height: width)
        let frameTwo = CGRect(x: width, y: 0, width: width, height: width)
        let frameThree = CGRect(x: width * 2, y: 0, width: width, height: width)
        let frameFour = CGRect(x: width * 3, y: 0, width: width, height: width)
        return [frameOne, frameTwo, frameThree, frameFour]
    }
    
    //for animation :)
    
//    fileprivate func startVectors() -> [SCNVector3] {
//
//    }
//
//    fileprivate func endVectors() -> [SCNVector3] {
//
//    }
    
    fileprivate func colors() -> [UIColor] {
        return [UIColor.blue, UIColor.green, UIColor.red, UIColor.purple]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
