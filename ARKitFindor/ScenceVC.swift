//
//  ViewController.swift
//  ARKitFindor
//
//  Created by Khaled Fakharany on 10/2/19.
//  Copyright © 2019 Khaled Fakharany. All rights reserved.
//

import ARKit
import FocusNode
import SCNPath
import SmartHitTest

extension ARSCNView: ARSmartHitTest {}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.focusSquare.updateFocusNode()
        }
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.state == .ended else {
            return
        }
        if self.focusSquare.state != .initializing {
            drawPath(y: self.focusSquare.position.y)
        }
    }
}

extension ViewController {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical, let geom = ARSCNPlaneGeometry(device: MTLCreateSystemDefaultDevice()!) {
            geom.update(from: planeAnchor.geometry)
            geom.firstMaterial?.colorBufferWriteMask = .alpha
            node.geometry = geom
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical, let geom = node.geometry as? ARSCNPlaneGeometry {
            geom.update(from: planeAnchor.geometry)
        }
    }
}

class ViewController: UIViewController {
    
    var originPosition: (x:Float,y:Float)!
    var destinationPosition:(x:Float,y:Float)!
    
    var sceneView = ARSCNView(frame: .zero)
    
    let focusSquare = FocusSquare()
    
    var hitPoints = [SCNVector3]() {
        didSet {
            self.pathNode.path = self.hitPoints
        }
    }
    
    var pathNode = SCNPathNode(path: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.frame = self.view.bounds
        self.sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(sceneView)
        
        // Set the view's delegate
        self.sceneView.delegate = self
        
        self.focusSquare.viewDelegate = self.sceneView
        self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
        
        // the next chunk of lines are just things I've added to make the path look nicer
        let pathMat = SCNMaterial()
        self.pathNode.materials = [pathMat]
        self.pathNode.position.y += 0.05
        pathMat.diffuse.contents = UIImage(named: "path_with_fade")
        self.pathNode.width = 0.5
        
        self.sceneView.scene.rootNode.addChildNode(self.pathNode)
        self.setupGestures()
        
        
    }
    
    func drawPath(y:Float){
        var xDiff: Float = 0.0
        var yDiff: Float = 0.0
        
        if originPosition.0 > destinationPosition.0 {
            xDiff = destinationPosition.0 - originPosition.0
        }else if originPosition.0 < destinationPosition.0 {
            xDiff = -1*(originPosition.0 - destinationPosition.0)
        }
        if originPosition.1 <= destinationPosition.1 {
            yDiff =  destinationPosition.1 - originPosition.1
        } else if originPosition.1 > destinationPosition.1 {
            yDiff =  -1*(originPosition.1 - destinationPosition.1)
        }
        let initialPoint = SCNVector3(0, y, 0)
        let midPoint = SCNVector3(0, y, yDiff/3)
        let secondMidPoint = SCNVector3(xDiff, y, yDiff/3)
        let finalPoint = SCNVector3(xDiff, y, yDiff)
        hitPoints = [initialPoint,midPoint,secondMidPoint,finalPoint]
        
        print(xDiff,yDiff)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}
