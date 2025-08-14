//
//  ARTestController.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/10/26.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreMotion

class ARTestController: BaseViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var aimLabel: UILabel!
    @IBOutlet weak var notReadyLabel: UILabel!
    @IBOutlet var sceneView: ARSCNView!
    
    private let session = ARSession()
    private let vectorZero = SCNVector3()
    private let sessionConfig: ARConfiguration = ARWorldTrackingConfiguration()
    private var measuring = false
    private var startValue = SCNVector3()
    private var endValue = SCNVector3()
    
    private let sceneView2 = SCNView()
    // 相机Node
    private let cameraNode = SCNNode()
    // 球体
    private let sphere = SCNSphere()
    
    private let motion = CMMotionManager()
    private var timer: DispatchSourceTimer?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScene()
//        startDeviceMotion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.pause()
        motion.stopDeviceMotionUpdates()
        endDeviceMotion()
    }

    private func setupARSence() {
        sceneView.delegate = self
        sceneView.session = session
        
        session.run(sessionConfig, options: [.resetTracking, .removeExistingAnchors])
        
//        resetValues()
    }
    
    private func setupScene() {
//        sceneView2.scene = SCNScene()
//        sceneView2.frame = view.frame
////        sceneView2.allowsCameraControl = false
//        view.addSubview(sceneView2)
//
//        sphere.radius = 50
//        sphere.firstMaterial?.isDoubleSided = false
//        sphere.firstMaterial?.cullMode = .front
//        sphere.firstMaterial?.diffuse.contents = flipImageLeftRight(UIImage(named: "thumb18")!)
//
//        let sphereNode = SCNNode(geometry: sphere)
//        sphereNode.position = SCNVector3Make(0, 0, 0)
//        sceneView2.scene?.rootNode.addChildNode(sphereNode)
//
//        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3Make(0, 0, 0)
//        sceneView2.scene?.rootNode.addChildNode(cameraNode)
        
        sceneView.isHidden = true
        
        let scene = SCNScene(named: "art.scnassets/Menchi.dae")
        let node = scene?.rootNode.childNodes.first
        // 绕y轴一直旋转
        let action = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1))
        node?.runAction(action)
        node?.transform = SCNMatrix4MakeScale(5, 5, 5)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene?.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3Make(0, 1, 15)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3Make(0, 10, 10)
        scene?.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene?.rootNode.addChildNode(ambientLightNode)
        
        let ship = scene?.rootNode.childNode(withName: "Menchi", recursively: true)
        ship?.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)))
        
        let scnView = SCNView(frame: view.bounds)
        scnView.scene = scene
        scnView.backgroundColor = UIColor.black
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        view.addSubview(scnView)
    }
    
    func flipImageLeftRight(_ image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: image.size.width, y: image.size.height)
        context.scaleBy(x: -image.scale, y: -image.scale)
        context.draw(image.cgImage!, in: CGRect(origin:CGPoint.zero, size: image.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func resetValues() {
        measuring = false
        startValue = SCNVector3()
        endValue = SCNVector3()
        
        updateResultLabel(0.0)
    }
    
    private func updateResultLabel(_ value: Float) {
        let cm = value * 100.0
        let inch = cm*0.3937007874
        resultLabel.text = String(format: "%.2f cm / %.2f\"", cm, inch)
    }
    
    private func detectObjects() {
        if let worldPos = sceneView.realWorldVector(screenPos: view.center) {
            aimLabel.isHidden = false
            notReadyLabel.isHidden = true
            if measuring {
                if startValue == vectorZero {
                    startValue = worldPos
                }
                
                endValue = worldPos
                updateResultLabel(startValue.distance(from: endValue))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetValues()
        measuring = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        measuring = false
    }
    
    //MARK: - core motion
    private func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 1.0 / 60.0
            motion.showsDeviceMovementDisplay = true
            motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
//            timer = CommonFunction.createGCDTimer(interval: .microseconds(161), handler: {
//                if let data = self.motion.deviceMotion {
//                    let x = data.attitude.pitch
//                    let y = data.attitude.roll
//                    let z = data.attitude.yaw
//
//                    print("x: \(x), y: \(y), z: \(z)")
//                }
//            })
        }
    }
    
    private func endDeviceMotion() {
        if timer != nil {
            timer?.cancel()
            timer = nil
        }
    }
}

extension ARTestController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.detectObjects()
        }
    }
}

extension SCNVector3: Equatable {
    public static func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }
    
    static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    fileprivate func distance(from vector: SCNVector3) -> Float {
        let distanceX = self.x - vector.x
        let distanceY = self.y - vector.y
        let distanceZ = self.z - vector.z
        
        return sqrtf( (distanceX * distanceX) + (distanceY * distanceY) + (distanceZ * distanceZ))
    }
}

extension ARSCNView {
    fileprivate func realWorldVector(screenPos: CGPoint) -> SCNVector3? {
//        let planeTestResults = self.hitTest(screenPos, types: [.featurePoint])
//        if let result = planeTestResults.first {
//            return SCNVector3.positionFromTransform(result.worldTransform)
//        }
        
        //iOS 14+
        guard let query = self.raycastQuery(from: screenPos, allowing: .existingPlaneInfinite, alignment: .horizontal) else { return nil }
        let results = self.session.raycast(query)
        if let result = results.first {
            return SCNVector3.positionFromTransform(result.worldTransform)
        }
        
        return nil
    }
}
