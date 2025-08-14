//
//  UIView+Utility.swift
//  SwiftTest
//
//  Created by bfgjs on 2019/3/1.
//  Copyright © 2019 ZhangLiang. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    // MARK: - xib设置圆角
    @IBInspectable var xibCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = (newValue > 0)
            layer.cornerRadius = newValue
        }
    }
    
    func getCurrentViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.getCurrentViewController()
        } else {
            return nil
        }
    }
    
    //MARK: - layer
    func addBottomLine(with height: CGFloat, color: UIColor) {
        addNormalLayer(with: CGRect(x: 0, y: self.frame.size.height - height, width: self.frame.size.width, height: height), color: color)
    }
    
    private func addNormalLayer(with frame: CGRect, color: UIColor) {
        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = color.cgColor
        self.layer.addSublayer(layer)
    }
    
    //圆角
    func roundCorners(corners: UIRectCorner, radius: CGFloat, hasShadow: Bool = false) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        if hasShadow {
            layer.shadowRadius = 8
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        }
        
        layer.mask = mask
    }
    
    @available(iOS 11.0, *)
    func maskCorner(corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
    
    //渐变色
    func setGradient(colors: [CGColor], locations: [NSNumber], superView: UIView, cornerRadius: CGFloat) {
        let layer = CAGradientLayer()
        layer.frame = self.frame
        layer.startPoint = CGPoint.zero
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.colors = colors
        layer.locations = locations
        
        if cornerRadius > 0 {
            layer.cornerRadius = cornerRadius
        }
        
        superview?.layer.insertSublayer(layer, at: 0)
    }
    
    //MARK: - direction
    func flipHorizontally() {
        let scaleX = self.transform.a == 1 ? -1 : 1
        self.transform = self.transform.scaledBy(x: CGFloat(scaleX), y: 1)
   }

    func setAlignment(isRTL: Bool){
      if let label = self as? UILabel {
            label.textAlignment = isRTL ? .right : .left
      }else if let textField = self as? UITextField{
         textField.textAlignment = isRTL ? .right : .left
      }
   }

   func adjustForLayoutDirection(isRTL: Bool) {
        self.flipHorizontally()
       setAlignment(isRTL: isRTL)

       if subviews.isEmpty{ return }
           for view in subviews {
               view.adjustForLayoutDirection(isRTL:isRTL)
        }

    }
    
    //use
    func changeLayout (isRTL: Bool) {
         if let window = UIApplication.shared.windows.first {
            for subview in window.subviews {
                  subview.adjustForLayoutDirection(isRTL: isRTL)
           }
        }
    }
    
    //MARK: - tap gesture
    func addTapGesture(target: Any, action: Selector) {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
    
    func addPanGesture(target: Any, action: Selector) {
        let gesture = UIPanGestureRecognizer(target: target, action: action)
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
    }
    
    //MARK: - animation
//    UIImageView().startPraiseAnimation(fromValue: 1.0, toValue: 0.7, autoreverses: true, duration: 1.0, repeatCount: 1, fileMode: CAMediaTimingFillMode.forwards.rawValue, keyType: "scaleAnimation")
    func startPraiseAnimation(fromValue: CGFloat, toValue: CGFloat, autoreverses: Bool, duration: CGFloat, repeatCount: CGFloat, fileMode: CAMediaTimingFillMode = .forwards, keyType: String = "scaleAnimation") {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = fromValue
        scaleAnimation.toValue = toValue
        scaleAnimation.autoreverses = autoreverses
        scaleAnimation.fillMode = fileMode
        scaleAnimation.repeatCount = Float(repeatCount)
        scaleAnimation.duration = CFTimeInterval(duration)
        
        layer.add(scaleAnimation, forKey: keyType)
    }
    
    //MARK: - shadow
    /// 使用默认阴影参数
    public func setViewShadow() {
        self.setViewShadow(radius: nil, color: nil, opacity: nil, offSet: nil)
    }
    
    /// 可以设置阴影参数
    public func setViewShadow(radius: CGFloat?, color: UIColor?, opacity: Float?, offSet: CGSize?){
        self.layer.shadowColor = (color ?? UIColor.black).cgColor
        self.layer.shadowRadius = radius ?? 4
        self.layer.shadowOffset = offSet ?? CGSize.zero
        self.layer.shadowOpacity = opacity ?? 0.1
    }
    
    /// 设置顶部阴影
    func setTopShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.3
        let pathWidth = layer.shadowRadius
        let shadowRect = CGRect(x: 0, y: -pathWidth/2, width: self.zl_width, height: pathWidth)
        let path = UIBezierPath(rect: shadowRect)
        layer.shadowPath = path.cgPath
    }
    
    //MARK: - frame
    var zl_left: CGFloat {
        get {
            return frame.origin.x
        }
        
        set {
            var tempFrame = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    var zl_top: CGFloat {
        get {
            return frame.origin.y
        }
        
        set {
            var tempFrame = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    var zl_right: CGFloat {
        get {
            return frame.maxX
        }
        
        set {
            var tempFrame = frame
            tempFrame.origin.x = newValue - frame.size.width
            frame = tempFrame
        }
    }
    
    var zl_bottom: CGFloat {
        get {
            return frame.maxY
        }
        
        set {
            var tempFrame = frame
            tempFrame.origin.y = newValue - frame.size.height
            frame = tempFrame
        }
    }
    
    var zl_width: CGFloat {
        get {
            return frame.size.width
        }
        
        set {
            var tempFrame = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    var zl_height: CGFloat {
        get {
            return frame.size.height
        }
        
        set {
            var tempFrame = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }
    
    var zl_centerX: CGFloat {
        get {
            return center.x
        }
        
        set {
            center = CGPoint(x: newValue, y: center.y)
        }
    }
    
    var zl_centerY: CGFloat {
        get {
            return center.y
        }
        
        set {
            center = CGPoint(x: center.x, y: newValue)
        }
    }
}


enum ZLButtonImageEdgeInsetsStyle {
    case top, left, right, bottom
}

extension UIButton {
    func imagePosition(at style: ZLButtonImageEdgeInsetsStyle, space: CGFloat) {
        guard let imageV = imageView else { return }
        guard let titleL = titleLabel else { return }
        //获取图像的宽和高
        let imageWidth = imageV.frame.size.width
        let imageHeight = imageV.frame.size.height
        //获取文字的宽和高
        let labelWidth  = titleL.intrinsicContentSize.width
        let labelHeight = titleL.intrinsicContentSize.height
        
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        switch style {
        case .top:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space/2, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight - space/2, right: 0)
            break;
            
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2, bottom: 0, right: space)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space/2, bottom: 0, right: -space/2)
            break;
            
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space/2, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight - space/2, left: -imageWidth, bottom: 0, right: 0)
            break;
            
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + space/2, bottom: 0, right: -labelWidth - space/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space/2, bottom: 0, right: imageWidth + space/2)
            break;
            
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}

extension UIButton {
    //防抖处理
    private struct AssociatedKeys {
        static var eventInterval = "eventInterval"
        static var eventEnable = "eventEnable"
    }
    
    var eventInterval: TimeInterval {
        get {
            if let interval = objc_getAssociatedObject(self, &AssociatedKeys.eventInterval) as? TimeInterval {
                return interval
            }
            return 0.5
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.eventInterval, newValue as TimeInterval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var eventEnabled: Bool {
        get {
            if let enabled = objc_getAssociatedObject(self, &AssociatedKeys.eventEnable) as? Bool {
                return enabled
            }
            return false
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.eventEnable, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    class func zl_initializeMethod() {
        let selector = #selector(UIButton.sendAction(_:to:for:))
        let new_selector = #selector(new_sendAction(_:to:for:))
        
        let old_method = class_getInstanceMethod(UIButton.self, selector)
        let new_method = class_getInstanceMethod(UIButton.self, new_selector)
        
        guard let oldMethod = old_method, let newMethod = new_method else { return }
        
        if class_addMethod(UIButton.self, selector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)) {
            class_replaceMethod(UIButton.self, new_selector, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod))
        }else {
            method_exchangeImplementations(oldMethod, newMethod)
        }
    }
    
    @objc private func new_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if eventEnabled == false {
            eventEnabled = true
            new_sendAction(action, to: target, for: event)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + eventInterval) {
                self.eventEnabled = false
            }
        }
    }
}

extension UITextField {
    func setPlaceholderColor(placeholder: String, color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: color] as [NSAttributedString.Key : Any])
    }
}

extension UILabel {
    //MARK: - attributedString
    func setAttributeSpace(with string: String, alignment: NSTextAlignment = .left, spacing: CGFloat) {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byCharWrapping
        paraStyle.alignment = alignment
        if spacing > 0 {
            paraStyle.lineSpacing = spacing
        }
        paraStyle.hyphenationFactor = 1.0
        
        paraStyle.firstLineHeadIndent = 0.0;
        paraStyle.paragraphSpacingBefore = 0.0;
        paraStyle.headIndent = 0;
        paraStyle.tailIndent = 0;
        
        //设置字间距 NSKernAttributeName:@1.3f
        let dict = [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 14), NSAttributedString.Key.kern: "0.5", NSAttributedString.Key.paragraphStyle: paraStyle] as [NSAttributedString.Key : Any]
        let attributedString = NSMutableAttributedString(string: string, attributes: dict)
        
        attributedText = attributedString
    }
    
    func getSearchAttribute(keyword: String, lightString: String, textColor: UIColor = UIColor.red) {
        let attributeString = NSMutableAttributedString(string: lightString)
        let dict = [NSAttributedString.Key.foregroundColor:textColor] as [NSAttributedString.Key : Any]
        
//        if let encodeString = keyword.removingPercentEncoding {
//            let range = (lightString as NSString).range(of: encodeString)
//
//            let attributeString = NSMutableAttributedString(string: lightString)
//            attributeString.setAttributes(dict, range: range)
//
//            return attributeString
//        }
        
        let expression = try? NSRegularExpression(pattern: keyword, options: .caseInsensitive)
        expression?.enumerateMatches(in: lightString, options: .reportProgress, range: NSRange(location: 0, length: lightString.count), using: { (result, flags, stop) in
            attributeString.addAttributes(dict, range: result?.range ?? NSRange(location: 0, length: 0))
        })
        
        attributedText = attributeString
    }
    
    func addUnderLine() {
//        let dict = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.patternDash.rawValue | NSUnderlineStyle.styleSingle.rawValue]
        let dict = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedString = NSMutableAttributedString(string: text ?? "", attributes: dict)
        attributedText = attributedString
    }
    
    func addMiddleLine() {
        let dict = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        let attributedString = NSMutableAttributedString(string: text ?? "", attributes: dict)
        attributedText = attributedString
    }
    
    func setAttributeColor(with string: String, changeColor: UIColor, range: NSRange, sapcing: CGFloat = 0, textAlignment: NSTextAlignment = .left) {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor:changeColor], range: range)
        
        if sapcing > 0 {
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = sapcing
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paraStyle], range: NSMakeRange(0, string.count))
        }
        
        attributedText = attributedString
        self.textAlignment = textAlignment
    }
    
    func setAttributeFont(with string: String, changeFont: UIFont, range: NSRange, sapcing: CGFloat = 0, textAlignment: NSTextAlignment = .left) {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes([NSAttributedString.Key.font: changeFont], range: range)
        
        if sapcing > 0 {
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = sapcing
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paraStyle], range: NSMakeRange(0, string.count))
        }
        
        attributedText = attributedString
        self.textAlignment = textAlignment
    }
}

//MARK: - font
extension UIFont {
    class func zlFontWith(name: String, size: CGFloat) -> UIFont {
        if let font = UIFont(name: name, size: size) {
            return font
        }
        
        return UIFont.systemFont(ofSize: size)
    }
    
    class func zlPingFangSCRegular(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: PingFangRegularFontName, size: size) {
            return font
        }
        
        return UIFont.systemFont(ofSize: size)
    }
    
    class func zlPingFangSCMedium(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: PingFangMediumFontName, size: size) {
            return font
        }
        
        return UIFont.systemFont(ofSize: size)
    }
    
    class func zlPingFangSCSemibold(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: PingFangSemiboldFontName, size: size) {
            return font
        }
        
        return UIFont.systemFont(ofSize: size)
    }
}

extension UIImageView {
    /// 对图片做渐变效果
    func fadeTransition(){
        let transition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.isRemovedOnCompletion = true
        self.layer.add(transition, forKey: "imageView_fade_animation")
    }
    
    func set_HeaderImage(_ imageUrl: String?, placeholderImage: UIImage? = nil) {
        guard let source = URL(zlString: imageUrl) else { return }
        
        kf.setImage(with: source, placeholder: placeholderImage) { response in
            switch response {
            case .success(let result):
                self.image = result.image.clipHeaderImag()
                
            case .failure(_):
                print("failed ++++")
            }
        }
    }
    
    //倒影
    func inverted() {
        let image = UIImage(named: "peter.jpg")!
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height * 1.5))
        let imageView = UIImageView(image: image)
        containerView.addSubview(imageView)
        
        let invertedImageView = UIImageView(image: image)
        invertedImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
                                UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,]
        gradientLayer.frame = CGRect(x: 0, y: invertedImageView.bounds.midY, width: image.size.width, height: invertedImageView.bounds.midY)
        invertedImageView.layer.addSublayer(gradientLayer)
        invertedImageView.frame.origin.y = image.size.height
        containerView.addSubview(invertedImageView)
    }
}
