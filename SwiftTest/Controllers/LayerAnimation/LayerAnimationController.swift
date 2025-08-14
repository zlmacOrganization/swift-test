//
//  LayerAnimationController.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/8/23.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit

enum ReplicatorLayerType: Int {
    case circle = 0, wave, triangle, grid, shake, round, heart, turn
}

class LayerAnimationController: BaseViewController {
    var layerType: ReplicatorLayerType?
    
    private var tableView: UITableView!
    private let animationTypes: [String] = ["波纹 animation", "波浪 animation", "三角形 animation", "网格 animation", "条形 animation", "转圈 animation", "心 animation", "翻转 animation", "lottie animation"]

    override func viewDidLoad() {
        super.viewDidLoad()

       configureViews()
    }
    
    private func configureViews() {
        if let type = layerType {
            let width: CGFloat = 100
            var frame = CGRect(x: (kMainScreenWidth - width)/2, y: 150, width: width, height: width)
            switch layerType {
            case .shake:
                frame = CGRect(x: 80, y: 200, width: width, height: width)
            case .heart:
                frame = CGRect(x: 80, y: 200, width: width, height: width)
            default:
                frame = CGRect(x: (kMainScreenWidth - width)/2, y: 150, width: width, height: width)
            }
            
            let animationView = UIView(frame: frame)
            view.addSubview(animationView)
            animationView.layer.addSublayer(getReplicatorLayer(type))
            view.backgroundColor = UIColor.white
        }else {
            tableView = UITableView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = UIColor.white
            tableView.zl_registerCell(UITableViewCell.self)
            view.addSubview(tableView)
            
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}

extension LayerAnimationController {
    func getReplicatorLayer(_ type: ReplicatorLayerType) -> CALayer {
        if type == .circle {
            return LayerAnimationController.circle_ReplicatorLayer()
        }else if type == .wave {
            return LayerAnimationController.wave_ReplicatorLayer()
        }else if type == .triangle {
            return LayerAnimationController.triangle_ReplicatorLayer()
        }else if type == .grid {
            return LayerAnimationController.grid_ReplicatorLayer()
        }else if type == .shake {
            return LayerAnimationController.shake_ReplicatorLayer()
        }else if type == .round {
            return LayerAnimationController.round_ReplicatorLayer()
        }else if type == .heart {
            return LayerAnimationController.heart_ReplicatorLayer()
        }else if type == .turn {
            return LayerAnimationController.turn_ReplicatorLayer()
        }else {
            return LayerAnimationController.circle_ReplicatorLayer()
        }
    }
    
    //圆圈动画 波纹
    class func circle_ReplicatorLayer() -> CALayer {
        let shapeLayer = CAShapeLayer()
        let frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        shapeLayer.frame = frame
        shapeLayer.path = UIBezierPath(ovalIn: frame).cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.opacity = 0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [alphaAnimation(), scaleAnimation()]
        animationGroup.duration = 4
        animationGroup.repeatCount = HUGE
        shapeLayer.add(animationGroup, forKey: "animationGroup")
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = frame
        replicatorLayer.instanceDelay = 0.5
        replicatorLayer.instanceCount = 8
        replicatorLayer.addSublayer(shapeLayer)
        
        return replicatorLayer
    }
    
    //波动动画
    class func wave_ReplicatorLayer() -> CALayer {
        let between: CGFloat = 5.0, radius: CGFloat = (100 - 2 * between)/3
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: (100 - radius)/2, width: radius, height: radius)
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius, height: radius)).cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.add(scaleAnimation1(), forKey: "scaleAnimation")
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        replicatorLayer.instanceDelay = 0.2
        replicatorLayer.instanceCount = 3
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(between*2+radius, 0, 0)
        replicatorLayer.addSublayer(shapeLayer)
        return replicatorLayer
    }
    
    //三角形动画
    class func triangle_ReplicatorLayer() -> CALayer {
        let radius: CGFloat = 25, transX: CGFloat = 75
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius, height: radius)).cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.add(rotationAnimation(transX), forKey: "rotateAnimation")
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        replicatorLayer.instanceDelay = 0
        replicatorLayer.instanceCount = 3
        var trans3D = CATransform3DIdentity
        trans3D = CATransform3DTranslate(trans3D, transX, 0, 0)
        trans3D = CATransform3DRotate(trans3D, 120.0*CGFloat.pi/180.0, 0, 0, 1)
        replicatorLayer.instanceTransform = trans3D
        replicatorLayer.addSublayer(shapeLayer)
        
        return replicatorLayer
    }
    
    //网格动画
    class func grid_ReplicatorLayer() -> CALayer {
        let between: CGFloat = 5.0, column = 3
        let radius: CGFloat = (100 - 2 * between)/3
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius, height: radius)).cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation1(), alphaAnimation()]
        animationGroup.duration = 1
        animationGroup.autoreverses = true
        animationGroup.repeatCount = HUGE
        shapeLayer.add(animationGroup, forKey: "groupAnimation")
        
        let replicatorLayerX = CAReplicatorLayer()
        replicatorLayerX.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        replicatorLayerX.instanceDelay = 0.3
        replicatorLayerX.instanceCount = column
        replicatorLayerX.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, radius + between, 0, 0)
        replicatorLayerX.addSublayer(shapeLayer)
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        replicatorLayer.instanceDelay = 0.3
        replicatorLayer.instanceCount = column
        replicatorLayer.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, 0, radius + between, 0)
        replicatorLayer.addSublayer(replicatorLayerX)
        
        return replicatorLayer
    }
    
    //震动条动画
    class func shake_ReplicatorLayer() -> CALayer {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 10, height: 80)
        layer.backgroundColor = UIColor.red.cgColor
        layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        layer.add(scaleYAnimation(), forKey: "scaleAnimation")
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        replicatorLayer.instanceCount = 6
        replicatorLayer.instanceDelay = 0.2
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(45, 0, 0)
        replicatorLayer.instanceGreenOffset = -0.3
        replicatorLayer.addSublayer(layer)
        return replicatorLayer
    }
    
    //转圈动画
    class func round_ReplicatorLayer() -> CALayer {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        layer.cornerRadius = 6
        layer.masksToBounds = true
        layer.backgroundColor = UIColor.purple.cgColor
        layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 1
        animation.repeatCount = MAXFLOAT
        animation.fromValue = 1
        animation.toValue = 0.01
        layer.add(animation, forKey: nil)
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        replicatorLayer.instanceCount = 9
        replicatorLayer.preservesDepth = true
        replicatorLayer.instanceColor = UIColor.white.cgColor
        replicatorLayer.instanceRedOffset = 0.1
        replicatorLayer.instanceGreenOffset = 0.1
        replicatorLayer.instanceBlueOffset = 0.1
        replicatorLayer.instanceAlphaOffset = 0.1
        replicatorLayer.instanceDelay = 1.0/9
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(2*CGFloat.pi/9, 0, 0, 1)
        replicatorLayer.addSublayer(layer)
        return replicatorLayer
    }
    
    //心动画
    class func heart_ReplicatorLayer() -> CALayer {
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        let subLayer = CALayer()
        subLayer.bounds = CGRect(x: 60, y: 105, width: 10, height: 10)
        subLayer.backgroundColor = UIColor(white: 0.8, alpha: 1).cgColor
        subLayer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        subLayer.borderWidth = 1.0
        subLayer.cornerRadius = 5.0
        subLayer.shouldRasterize = true
        subLayer.rasterizationScale = UIScreen.main.scale
        replicatorLayer.addSublayer(subLayer)
        
        let move = CAKeyframeAnimation(keyPath: "position")
//        move.path = [self heartPath]
        move.repeatCount = Float(FP_INFINITE)
        move.duration = 6.0
        subLayer.add(move, forKey: nil)
        
        replicatorLayer.instanceDelay = 6 / 50.0
        replicatorLayer.instanceCount = 50
        replicatorLayer.instanceColor = UIColor.orange.cgColor
        replicatorLayer.instanceGreenOffset = -0.03
        return replicatorLayer
    }
    
    //翻转动画
    class func turn_ReplicatorLayer() -> CALayer {
//        UIView.beginAnimations("animation", context: nil)
//        UIView.setAnimationDuration(0.5)
//        UIView.setAnimationCurve(.easeInOut)
//        UIView.setAnimationTransition(.flipFromRight, for: view, cache: false)
//        UIView.commitAnimations()
        
        let margin: CGFloat = 8, width: CGFloat = 80
        let dotW: CGFloat = (width - 2 * margin) / 3
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: (width - dotW) * 0.5, width: dotW, height: dotW)
        shapeLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: dotW, height: dotW)).cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: 0, y: 0, width: width, height: width)
        replicatorLayer.instanceCount = 3
        replicatorLayer.instanceDelay = 0.1
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(margin + dotW, 0, 0)
        replicatorLayer.addSublayer(shapeLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "transform")
        basicAnimation.fromValue = NSValue(caTransform3D: CATransform3DRotate(CATransform3DIdentity, 0, 0, 1.0, 0))
        basicAnimation.toValue = NSValue(caTransform3D: CATransform3DRotate(CATransform3DIdentity, CGFloat.pi, 0, 1, 0))
        basicAnimation.repeatCount = HUGE
        basicAnimation.duration = 0.6
        
        shapeLayer.add(basicAnimation, forKey: nil)
        
        return replicatorLayer
    }
    
    class func scaleYAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale.y")
        animation.toValue = 0.1
        animation.duration = 0.4
        animation.autoreverses = true
        animation.repeatCount = MAXFLOAT
        return animation
    }
    
    class func alphaAnimation() -> CABasicAnimation {
        let alpha = CABasicAnimation(keyPath: "opacity")
        alpha.fromValue = 1.0
        alpha.toValue = 0.0
        return alpha
    }
    
    class func scaleAnimation() -> CABasicAnimation {
        let scale = CABasicAnimation(keyPath: "transform")
        scale.fromValue = NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0))
        scale.toValue = NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0))
        return scale
    }
    
    class func scaleAnimation1() -> CABasicAnimation {
        let scale = CABasicAnimation(keyPath: "transform")
        scale.fromValue = NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0))
        scale.toValue = NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0.0))
        scale.autoreverses = true
        scale.repeatCount = HUGE
        scale.duration = 0.6
        return scale
    }
    
    class func rotationAnimation(_ transX: CGFloat) -> CABasicAnimation {
        let rotate = CABasicAnimation(keyPath: "transform")
        rotate.fromValue = NSValue(caTransform3D: CATransform3DRotate(CATransform3DIdentity, 0.0, 0.0, 0.0, 0.0))
        var toValue = CATransform3DTranslate(CATransform3DIdentity, transX, 0.0, 0.0)
        toValue = CATransform3DRotate(toValue, 120.0*CGFloat.pi/180.0, 0.0, 0.0, 1.0)
        rotate.toValue = toValue
        rotate.autoreverses = false
        rotate.repeatCount = HUGE
        rotate.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotate.duration = 0.8
        return rotate
    }
}

extension LayerAnimationController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animationTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = animationTypes[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == animationTypes.count - 1 {
//            let starAnimationView = AnimationView()
//            /// Some time later
//            let starAnimation = Animation.named("StarAnimation")
//            starAnimationView.animation = starAnimation
//            starAnimationView.play { (finished) in
//
//            }
        }else {
            let layerVC = LayerAnimationController()
            layerVC.layerType = ReplicatorLayerType(rawValue: indexPath.row)
            navigationController?.pushViewController(layerVC, animated: true)
        }
    }
}
