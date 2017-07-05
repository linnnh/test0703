//
//  SimpleBoxViewController.swift
//  Hello-AR
//
//  Created by Linne S. Huang on 7/2/17.
//  Copyright © 2017 Linne S. Huang. All rights reserved.
//

// # My notes would be displayed with hashtag

// import Foundation
import UIKit
import SceneKit
import ARKit

// # This is for creating collision:
enum BodyType : Int {
    case box = 1
    case plane = 2
}
// # # # END # # #


class SimpleBoxViewController: UIViewController, ARSCNViewDelegate {
    
    // var sceneView: ARSCNView!
    
    // # The tutorial is wrong. (!) You need to outlet the view in this swift file, in order to render your file.
    
    // # how to connect to different swift file? Click on the controller in main.storyboard, and select the swift file you want to show in "Identity and Type"
    @IBOutlet var sceneView: ARSCNView!
    
    // # Create a label that says "Plane Detected:3"
    private let label : UILabel = UILabel()
    
    // # Try to merge the planes (so that the planes will be updating)
    var planes = [OverlayPlane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // # We want the sceneView to display in the whole iPhone screen, so we set...
        self.sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(self.sceneView)
        
        
        // # Put a label and show "Plane Detected"
        self.label.frame = CGRect(x: 0, y: 0, width: self.sceneView.frame.size.width, height: 44)
        self.label.center = self.sceneView.center
        self.label.textAlignment = .center
        self.label.textColor = UIColor.white
        self.label.font = UIFont.preferredFont(forTextStyle: .headline)
        self.label.alpha = 0
        
        self.sceneView.addSubview(self.label)
        
        // # Debugging tool:
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene() // # We want to display the box, instead of the ship.
        
        // # Add some text!
        let textGeometry = SCNText(string: "Hey World :3", extrusionDepth: 1)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.white
        
        let textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(0, -0.3, -0.5)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        scene.rootNode.addChildNode(textNode)
        
        // # So let's create the box!
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.01)
        let material = SCNMaterial()
        material.name = "materialColor"
        material.diffuse.contents = UIColor.red
        //material.diffuse.contents = UIImage(named: "art.scnassets/doge.jpeg")
        
        // # And add the node:
        let node = SCNNode()
        node.geometry = box
        node.geometry?.materials = [material]
        node.position = SCNVector3(0, 0.1, -0.5)
        
        scene.rootNode.addChildNode(node)
        
        
        // # Create a sphere!
        let sphere = SCNSphere(radius: 0.2)
        let sphereMaterial = SCNMaterial()
        // sphereMaterial.diffuse.contents = UIColor.blue
        sphereMaterial.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
        
        let sphereNode = SCNNode()
        sphereNode.geometry = sphere
        sphereNode.geometry?.materials = [sphereMaterial]
        sphereNode.position = SCNVector3(0.5, 0.1, -1)
        sphereNode.scale = SCNVector3(1, 1, 1)
        
        // scene.rootNode.addChildNode(node)
        scene.rootNode.addChildNode(sphereNode)
        
        
        // # Add Tap Gesture!
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        
        // # Add orange!
        let orangeScene = SCNScene(named: "art.scnassets/Orange.scn")
        
        let orange = Orange(scene: orangeScene!)
        orange.name = "Orange"
        orange.position = SCNVector3(0, -1, -1)
        
//        let orangeNode = orangeScene?.rootNode.childNode(withName: "Orange", recursively: true)
//        orangeNode?.position = SCNVector3(0, -2, -0.5)
        
        
        
        scene.rootNode.addChildNode(orange)
        
        
        
        
        // Set the scene to the view
        sceneView.scene = scene
        
        
        // Add gesture recognizer
        registerGestureRecognizers()
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        
        // For creating the force
//        tapGestureRecognizer.numberOfTapsRequired = 1
//        let doubleTappedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
//        doubleTappedGestureRecognizer.numberOfTapsRequired = 2
//        tapGestureRecognizer.require(toFail: doubleTappedGestureRecognizer)
//        self.sceneView.addGestureRecognizer(doubleTappedGestureRecognizer)
        // END
        
        
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // For creating the force - NOT WORKING
//    @objc func doubleTapped(recognizer: UITapGestureRecognizer) {
//
//        let sceneView = recognizer.view as! ARSCNView
//        let touch = recognizer.location(in: sceneView)
//        let hitResults = sceneView.hitTest(touch, options: [:])
//
//        if !hitResults.isEmpty {
//            guard let hitResult = hitResults.first else {
//                return
//            }
//
//            let nodeForce = hitResults.node
//            nodeForce.physicsBody?.applyForce(SCNVector3(hitResults.worldCoordinates.x, hitResults.worldCoordinates.y, hitResults.worldCoordinates.z), amImpulse: true)
//
//        }
//
//    }
//
    
    
    @objc func tapped(recognizer : UITapGestureRecognizer) {
        
        // Click-and-Change-Color
//        let sceneView = recognizer.view as! SCNView
//        let touchLocation = recognizer.location(in: sceneView)
//
//        let hitResults = sceneView.hitTest(touchLocation, options: [:])
//
//
//        if !hitResults.isEmpty {
//            let node = hitResults[0].node
//            let material = node.geometry?.material(named: "materialColor")
//
//            material?.diffuse.contents = UIColor.random()
//
//
//        }
//
        
        // Click-and-Add-Cubes
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: sceneView)
        
        let hitTestResults = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        if !hitTestResults.isEmpty {
            guard let hitResult = hitTestResults.first else {
                return
            }
            addBox(hitResult: hitResult)
        }
        
        
        // Make orange fly!
        guard let orangeNode = self.sceneView.scene.rootNode.childNode(withName: "Orange", recursively: true) else {
            fatalError("Orange is not found :(")
        }
        
        orangeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        orangeNode.physicsBody?.isAffectedByGravity = false
        orangeNode.physicsBody?.damping = 0.0
        
        orangeNode.physicsBody?.applyForce(SCNVector3(0, 100, 0), asImpulse: false)
        
        
    }
    
    private func addBox(hitResult : ARHitTestResult) {
        
        let addBoxGeometry = SCNBox(width: 0.2, height: 0.2, length: 0.1, chamferRadius: 0)
        let addBoxMaterial = SCNMaterial()
        addBoxMaterial.diffuse.contents = UIColor.yellow
        
        addBoxGeometry.materials = [addBoxMaterial]
        
        let addBoxNode = SCNNode(geometry: addBoxGeometry)
        addBoxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        // create collisions
        addBoxNode.physicsBody?.categoryBitMask = BodyType.box.rawValue
        
        // first try!
//        addBoxNode.position = SCNVector3(
//            hitResult.worldTransform.columns.3.x,
//            hitResult.worldTransform.columns.3.y + Float(addBoxGeometry.height/2),
//            hitResult.worldTransform.columns.3.z
//        )
        
        // second try! Make the box falling down...
        addBoxNode.position = SCNVector3(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y + Float(0.5),
            hitResult.worldTransform.columns.3.z
        )
        
        self.sceneView.scene.rootNode.addChildNode(addBoxNode)
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        // # Add the plane detection!
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if !(anchor is ARPlaneAnchor) {
            return
        }
        
        let plane = OverlayPlane(anchor: anchor as! ARPlaneAnchor)
        self.planes.append(plane)
        node.addChildNode(plane)
        
        
        
        DispatchQueue.main.async {
            self.label.text = "Plane Detected"
            
            UIView.animate(withDuration: 3.0, animations: {
                
                self.label.alpha = 1.0
                print("***Plane Detected!")
                
            }) { (completion: Bool) in
                
                self.label.alpha = 0.0
                print("***Plane Detected closed!")
                
            }
            
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let plane = self.planes.filter { plane in
            return plane.anchor.identifier == anchor.identifier
        }.first
        
        if plane == nil {
            return
        }
        
        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    
}


// Making your extensions


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}


extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
}



// OverlayPlane!

class OverlayPlane : SCNNode {
    
    var anchor : ARPlaneAnchor
    var planeGeometry : SCNPlane!
    
    init (anchor : ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        setup()
    }
    
    func update (anchor : ARPlaneAnchor) {
        
        self.planeGeometry.width = CGFloat(anchor.extent.x);
        self.planeGeometry.height = CGFloat(anchor.extent.z);
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        
        let planeNode = self.childNodes.first!
        
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        
        
    }
    
    private func setup() {
        
        // create the plane
        self.planeGeometry = SCNPlane(width: CGFloat(self.anchor.extent.x), height: CGFloat(self.anchor.extent.z))
        
        let materialPlane = SCNMaterial()
        materialPlane.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        
        self.planeGeometry.materials = [materialPlane]
        
        let planeNode = SCNNode(geometry : self.planeGeometry)
        // For creating collisions
        planeNode.physicsBody = SCNPhysicsBody(type: .static,
                                               shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        planeNode.physicsBody?.categoryBitMask = BodyType.plane.rawValue
        
        
        // set the position for the plane
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0);
        
        // add to the parent
        self.addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
    
}


// Create a new Orange class...

class Orange : SCNNode {
    
    private var scene : SCNScene!
    
    init(scene : SCNScene) {
        super.init()
        self.scene = scene
        
        setup()
    }
    
    init(orangeNode : SCNNode) {
        super.init()
        
        setup()
    }
    
    private func setup() {
        guard let orangeNode = self.scene.rootNode.childNode(withName: "Orange", recursively: true),
            let smokeNode = self.scene.rootNode.childNode(withName: "smokeNode", recursively: true)
            
            
        else {
            fatalError("Node is not found:(")
        }
        
        let smoke = SCNParticleSystem(named: "smoke.scnp", inDirectory: nil)
        smokeNode.addParticleSystem(smoke!)
        
        self.addChildNode(orangeNode)
        self.addChildNode(smokeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

















