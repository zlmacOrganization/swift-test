//
//  NetWorkViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 16/12/17.
//  Copyright © 2016年 ZhangLiang. All rights reserved.
//

import UIKit
import StoreKit
import MobileCoreServices

class NetWorkViewController: BaseViewController {
    
    private var progressView: ZLAuditProgressView!
    private var isTransFormed: Bool = false
    
    private var drawView: UIView!
    private let viewWidth: CGFloat = 70
    private let viewHeight: CGFloat = 100
    private let trangleWidth: CGFloat = 12
    
    private var transitionDelegate: TransitionUtil {
        return self.transitioningDelegate as? TransitionUtil ?? TransitionUtil()
    }

    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addPanGesture(target: self, action: #selector(verticalPanHandle(_:)))
        
        var labelString = "test label"

        if doesCameraSupportTakingPhotos() {
//            print("The camera supports taking photos")
            labelString = "The camera supports taking photos"
        }else{
//            print("The camera does not supports taking photos")
            labelString = "The camera does not supports taking photos"
        }
        
        configureLabelWithString(withString: labelString)
        
        addAttributeLabel()
        test()
        
        progressView = ZLAuditProgressView(frame: CGRect(x: 40, y: 220, width: kMainScreenWidth - 80, height: 60), titles: ["报备", "到访", "认购", "成交", "结佣"], progress: 2)
        CommonFunction.addTapGesture(with: progressView, target: self, action: #selector(transform))
        view.addSubview(progressView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureLabelWithString(withString: String) {
        let label = CommonFunction.createLabel(frame: CGRect(x: 20, y: 20, width: kMainScreenWidth - 40, height: 24), text: "", font: UIFont.systemFont(ofSize: 16), textColor: UIColor.darkGray, textAlignment: .center)
        
        label.setAttributeColor(with: withString, changeColor: UIColor.purple, range: NSMakeRange(withString.count - 6, 6), textAlignment: .center)
        self.view.addSubview(label)
    }
    
    private func cameraSupporsMedia(mediaType: String, sourceType: UIImagePickerController.SourceType) -> Bool {
//        let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: sourceType)
        
//        if (availableMediaTypes?.isEmpty)! {
//            for type in (availableMediaTypes)! {
//                if type == mediaType {
//                    return true
//                }
//            }
//        }
        
        return false
    }
    
    private func doesCameraSupportShootingVideos() -> Bool {
        return cameraSupporsMedia(mediaType: kUTTypeMovie as String, sourceType: .camera)
    }
    
    private func doesCameraSupportTakingPhotos() -> Bool {
        return cameraSupporsMedia(mediaType: kUTTypeImage as String, sourceType: .camera)
    }
    
    private func compareTwoDate() {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = formatter1.date(from: CommonFunction.getCurrentTimeString(format: "yyyy-MM-dd HH:mm:ss"))
        let date2 = formatter1.date(from: "2018-02-22 14:30:19")
        
        let compare = CommonFunction.compareDate(with: date1!, anotherDay: date2!, format: "yyyy-MM-dd HH:mm:ss")
        print("compare = \(compare)")
    }
    
    //MARK: -
    private func addAttributeLabel() {
        let text = "京东 满减优惠券，快来抢 《隐私政策》 京东 满减优惠券，快来抢"
        let label = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: "", textColor: UIColor.darkGray, textAlignment: .left)
        label.numberOfLines = 0
        label.addTapGesture(target: self, action: #selector(labelLinkClick))
        view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        let tagLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: "满减优惠", textColor: UIColor.white, textAlignment: .center)
        tagLabel.backgroundColor = UIColor.red
        view.addSubview(tagLabel)
        
        tagLabel.snp.makeConstraints { (make) in
            make.top.equalTo(label)
            make.left.equalTo(10)
            make.width.equalTo(60)
        }
        
        let att = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 60
        style.lineSpacing = 2
        att.addAttribute(.paragraphStyle, value: style, range: .init(location: 0, length: att.length))
        att.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: .init(location: 0, length: att.length))
        att.addAttribute(.foregroundColor, value: UIColor.darkGray, range: .init(location: 0, length: att.length))
//        att.addAttribute(.link, value: "https://baidu.com", range: NSRange(text.range(of: "《隐私政策》")!, in: text))
        att.addAttribute(.foregroundColor, value: UIColor.red, range: text.nsRange(of: "《隐私政策》"))
        label.attributedText = att
        
        textWithImage()
    }
    
    @objc private func labelLinkClick(gusture: UITapGestureRecognizer) {
//        let label = gusture.view as! UILabel
        
        ZFPrint("click label link")
    }
    
    private func textWithImage() {
        let text = "京东满减优惠券，快来抢"
        let label = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 15), text: "", textColor: UIColor.darkGray, textAlignment: .center)
        label.numberOfLines = 0
        view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(104)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        let attributeString = NSMutableAttributedString(string: text)
        let image = UIImage(named: "wxFriends_share")
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: -3, width: 15, height: 15)
        let imageAtrtibute = NSAttributedString(attachment: attachment)
        attributeString.insert(imageAtrtibute, at: 0)
        
        setAttrribute(label: label, attributeText: attributeString, images: [image!], iamgeSpace: 0)
        
        label.attributedText = attributeString
    }
    
    private func test() {
        let viewWidth = (kMainScreenWidth - 30)/2
        let viewY: CGFloat = 140
        let leftView = UIView(frame: CGRect(x: 10, y: viewY, width: viewWidth, height: 40))
        CommonFunction.addTapGesture(with: leftView, target: self, action: #selector(displayOverlay))
        view.addSubview(leftView)
        
        setupInfoViews_leftAlignment(infoView: leftView, infos: ["乒乓球", "羽毛球", "足球", "橄榄球", "篮球", "网球", "排球"], viewWidth: viewWidth, labelHeight: 20, font: UIFont.systemFont(ofSize: 15))
        
        let rightView = UIView(frame: CGRect(x: kMainScreenWidth - viewWidth - 10, y: viewY, width: viewWidth, height: 40))
        CommonFunction.addTapGesture(with: rightView, target: self, action: #selector(showStoreProduct))
        view.addSubview(rightView)
        
        setupInfoViews_rightAlignment(infoView: rightView, infos: ["乒乓球", "羽毛球", "足球", "橄榄球", "篮球", "网球", "排球"], viewWidth: viewWidth, labelHeight: 20, font: UIFont.systemFont(ofSize: 15))
    }
    
    private func setupInfoViews_rightAlignment(infoView: UIView, infos: [String], viewWidth: CGFloat, labelHeight: CGFloat, font: UIFont) {
        var labelX = viewWidth
        var labelY: CGFloat = 0
        
        for (i, info) in infos.enumerated() {
            var wordWidth = CommonFunction.getTextWidth(string: info, font: font, height: labelHeight)
            if wordWidth > viewWidth {
                wordWidth = viewWidth
            }
            
            if i == 0 {
                labelX = viewWidth - wordWidth
            }else {
                let margin = wordWidth + 8
                labelX -= margin
            }
            
            if labelX < 0 {
                labelY += labelHeight + 10
                labelX = viewWidth - wordWidth
            }
            
            let label = CommonFunction.createLabel(frame: CGRect(x: labelX, y: labelY, width: wordWidth, height: labelHeight), text: info, font: font, textColor: UIColor.white, textAlignment: .center)
            label.backgroundColor = UIColor.purple
            infoView.addSubview(label)
        }
    }
    
    private func setupInfoViews_leftAlignment(infoView: UIView, infos: [String], viewWidth: CGFloat, labelHeight: CGFloat, font: UIFont) {
        var labelX: CGFloat = 0
        var labelY: CGFloat = 0
        
        for info in infos {
            var wordWidth = CommonFunction.getTextWidth(string: info, font: font, height: labelHeight)
            if wordWidth > viewWidth {
                wordWidth = viewWidth
            }
            
            if labelX + wordWidth > viewWidth {
                labelY += labelHeight + 10
                labelX = 0
            }
            
            let label = CommonFunction.createLabel(frame: CGRect(x: labelX, y: labelY, width: wordWidth, height: labelHeight), text: info, font: font, textColor: UIColor.white, textAlignment: .center)
            label.backgroundColor = UIColor.purple
            infoView.addSubview(label)
            
            labelX += wordWidth + 8
        }
    }
    
    private func getInfosHeight_rightAlignment(infos: [String], bgWidth: CGFloat, viewWidth: CGFloat, viewHeight: CGFloat, labelHeight: CGFloat, font: UIFont) -> CGFloat {
        
        if infos.isEmpty {
            return viewHeight
        }
        
        var labelX = viewWidth
        var labelY = viewHeight
        
        for (i, info) in infos.enumerated() {
            var wordWidth = CommonFunction.getTextWidth(string: info, font: font, height: labelHeight)
            if wordWidth > viewWidth {
                wordWidth = viewWidth
            }
            
            if i == 0 {
                labelX = viewWidth - wordWidth
            }else {
                let margin = wordWidth + 8
                labelX -= margin
            }
            
            if labelX < 0 {
                labelY += labelHeight + 10
                labelX = viewWidth - wordWidth
            }
        }
        
        return labelY
    }
    
    private func getInfosHeight_leftAlignment(infos: [String], bgWidth: CGFloat, viewWidth: CGFloat, viewHeight: CGFloat, labelHeight: CGFloat, font: UIFont) -> CGFloat {
        
        if infos.isEmpty {
            return viewHeight
        }
        
        var labelX = viewWidth
        var labelY = viewHeight
        
        for info in infos {
            var wordWidth = CommonFunction.getTextWidth(string: info, font: font, height: labelHeight)
            if wordWidth > viewWidth {
                wordWidth = viewWidth
            }
            
            if labelX + wordWidth > viewWidth {
                labelY += labelHeight + 10
                labelX = 0
            }
            
            labelX += wordWidth + 8
        }
        
        return labelY
    }
    
    //MARK: - attribute image
    
    private func setAttrribute(label: UILabel, attributeText: NSMutableAttributedString?, images: [UIImage], iamgeSpace: CGFloat) {
        
        var attributeString = attributeText
        
        if attributeString == nil {
            attributeString = NSMutableAttributedString(string: label.text ?? "")
        }
        
        for image in images {
            let attachment = NSTextAttachment()
            attachment.image = image
            
            let imgH = label.font.pointSize
            let imgW = (image.size.width / image.size.height) * imgH
            let topPading = (label.font.lineHeight - imgH)/2
            attachment.bounds = CGRect(x: 0, y: -topPading, width: imgW, height: imgH)
            
            let imageAtrtibute = NSAttributedString(attachment: attachment)
            attributeString?.append(imageAtrtibute)
        }
        
        label.attributedText = attributeString
    }
    
    //MARK: - animation
    @objc private func transform() {
        isTransFormed.toggle()

        if isTransFormed {

            UIView.animate(withDuration: 0.8, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                self.progressView.transform = CGAffineTransform(translationX: 0, y: kMainScreenHeight/2)
            }) { (finished) in
                self.progressView.transform = CGAffineTransform.identity
            }
        }else {
//            self.testView.transform = CGAffineTransform(translationX: kMainScreenWidth, y: 0)
            
            UIView.animate(withDuration: 0.8, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                self.progressView.transform = CGAffineTransform(translationX: 0, y: -kMainScreenHeight/4)
            }) { (finished) in
                self.progressView.transform = CGAffineTransform.identity
            }
        }
        
//        testView.transform = CGAffineTransform.identity.translatedBy(x: 50, y: 50)
        
//        startAnimation(type: CATransitionType(rawValue: "pageCurl"))
//        startAnimation(type: CATransitionType(rawValue: "pageUnCurl"))
//        startAnimation(type: CATransitionType(rawValue: "rippleEffect"))
//        startAnimation(type: CATransitionType(rawValue: "suckEffect"))
//        startAnimation(type: CATransitionType(rawValue: "cube"))
//        startAnimation(type: CATransitionType(rawValue: "olgFilp"))
        
//        startAnimation(type: .fade)
//        startAnimation(type: .moveIn)
//        startAnimation(type: .push)
//        startAnimation(type: .reveal)
    }
    
    private func startAnimation(type: CATransitionType) {
        let transition = CATransition()
        transition.duration = 1.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
        transition.type = type
        transition.subtype = .fromTop
        
        progressView.layer.add(transition, forKey: "transition")
    }
    
    //MARK: - Bezier
    private func drawLineAndArc() {
        let x = (kMainScreenWidth - viewWidth)/2
        let y = kMainScreenHeight/2 + 70
        
        drawView = UIView(frame: CGRect(x: x, y: y, width: viewWidth, height: viewHeight))
//        drawView.backgroundColor = UIColor.white
        CommonFunction.addTapGesture(with: drawView, target: self, action: #selector(viewClick))
        view.addSubview(drawView)
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: x + viewWidth, y: y))
        linePath.addLine(to: CGPoint(x: x + viewWidth - 12, y: y))
        linePath.addLine(to: CGPoint(x: x + viewWidth - 12 - trangleWidth/2, y: y - trangleWidth))
        linePath.addLine(to: CGPoint(x: x + viewWidth - 12 - trangleWidth, y: y))
        linePath.addLine(to: CGPoint(x: x, y: y))
        
        linePath.addLine(to: CGPoint(x: x, y: y + viewHeight))
        linePath.addLine(to: CGPoint(x: x + viewWidth, y: y + viewHeight))
        
        linePath.close()
        
        let layer = CAShapeLayer()
        layer.frame = drawView.bounds
        layer.lineWidth = 1
        layer.strokeColor = UIColor.purple.cgColor
//        layer.fillColor = nil
        layer.path = linePath.cgPath
        
        drawView.layer.addSublayer(layer)
//        drawView.layer.mask = layer
    }
    
    @objc private func viewClick() {
        self.pleaseWait()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.clearAllNotice()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.noticeOnlyText("请输入手机号")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.noticeSuccess("success!")
//                    self.noticeInfo("info")
//                    self.noticeError("error")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.clearAllNotice()
                }
            }
        }
    }
    
    //MARK: - graphic
    private func drawRectAtTopOfScreen() {
        let currentContext = UIGraphicsGetCurrentContext()
        let offect = CGSize(width: 10, height: 10)
        currentContext?.setShadow(offset: offect, blur: 20, color: UIColor.gray.cgColor)
        let path = CGMutablePath()
        let firstRect = CGRect(x: 55, y: 60, width: 150, height: 150)
//        CGPathAddRect(path, nil, firstRect)
        path.addRect(firstRect)
        currentContext?.addPath(path)
        UIColor(red: 0.20, green: 0.60, blue: 0.80, alpha: 1.0).setFill()
//        CGContextDrawPath(currentContext, kCGPathFill)
//        CGContext.draw(currentContext)
        currentContext?.drawPath(using: .fill)
    }
        
    private func drawRectAtBottomOfScreen() {
        let currentContext = UIGraphicsGetCurrentContext()
        let secondPath = CGMutablePath()
        let secondRect = CGRect(x: 150, y: 250, width: 100, height: 100)
        secondPath.addRect(secondRect)
        currentContext?.addPath(secondPath)
        
        UIColor.purple.setFill()
        currentContext?.drawPath(using: .fill)
    }
    
    private func setShadowView() {
        let currentContext = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let startColor = UIColor.blue
        let startColorComponents = startColor.cgColor.components
        
        let endColor = UIColor.green
        let endColorComponents = endColor.cgColor.components
        
        let colorComponents = [startColorComponents?[0], startColorComponents?[1], startColorComponents?[2], startColorComponents?[3], endColorComponents?[0], endColorComponents?[1], endColorComponents?[2], endColorComponents?[3]]
        
        let colorIndices = [0.0, 1.0] as [CGFloat]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colorComponents as CFArray, locations: colorIndices)
        
        let screenBounds = UIScreen.main.bounds
        let startPoint = CGPoint(x: 0, y: screenBounds.size.height/2)
        let endPoint = CGPoint(x: screenBounds.size.width, y: startPoint.y)
        
//        CGContext.drawLinearGradient(currentContext, gradient, startPoint, endPoint, 0)
        currentContext?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
    }
    
    //MARK: - imagePicker
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        // Local variable inserted by Swift 4.2 migrator.
//        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//        print("Picker returned successfully")
//        
//        let mediaType: AnyObject? = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as AnyObject?
//        
//        if let type: AnyObject = mediaType {
//            if type is String {
//                let stringType = type as! String
//                if stringType == kUTTypeImage as String {
//                    var theImage: UIImage!
//                    if picker.allowsEditing {
//                        theImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
//                    }else{
//                        theImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
//                    }
//                    
//                    let selectorAsString = "imageWasSavedSuccessfully:didFinishSavingWithError:context:"
//                    let selectorToCall = Selector(selectorAsString)
//                    UIImageWriteToSavedPhotosAlbum(theImage, self, selectorToCall, nil)
//                }
//            }
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

//MARK: - keyboard
extension NetWorkViewController {
    @objc private func showStoreProduct() {
        let productVC = SKStoreProductViewController()
        productVC.delegate = self
        let dict = [SKStoreProductParameterITunesItemIdentifier: "414478124"]
        self.present(productVC, animated: true, completion: nil)
        productVC.loadProduct(withParameters: dict) { (invoked, error) in
            if invoked {
                ZFPrint("present success")
            }
        }
    }
    
    @objc private func displayOverlay() {
        if #available(iOS 14.0, *) {
            guard let scene = view.window?.windowScene else { return }
            
            let config = SKOverlay.AppConfiguration(appIdentifier: "1372629880", position: .bottom)
            let overlay = SKOverlay(configuration: config)
            overlay.delegate = self
            overlay.present(in: scene)
        }
    }
    
    @objc private func verticalPanHandle(_ pan: UIPanGestureRecognizer) {
        let translationY = pan.translation(in: view).y
        let absY = abs(translationY)
        let progress = absY / view.frame.height
        print("progress: \(progress)")
        
        switch pan.state {
        case .began:
            transitionDelegate.interactive = true
            //如果转场代理提供了交互控制器，它将从这时候开始接管转场过程。
            self.dismiss(animated: true, completion: nil)
            
        case .changed:
            transitionDelegate.interactionTransition.update(progress)
            
        case .cancelled, .ended:
            if progress > 0.3 {
                transitionDelegate.interactionTransition.completionSpeed = 0.99
                transitionDelegate.interactionTransition.finish()
            }else {
                transitionDelegate.interactionTransition.completionSpeed = 0.99
                transitionDelegate.interactionTransition.cancel()
            }
            transitionDelegate.interactive = false
            
        default:
            break
        }
    }
}

extension NetWorkViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

@available(iOS 14.0, *)
extension NetWorkViewController: SKOverlayDelegate {
    func storeOverlayDidFinishPresentation(_ overlay: SKOverlay, transitionContext: SKOverlay.TransitionContext) {
        guard let scene = view.window?.windowScene else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            SKOverlay.dismiss(in: scene)
        }
    }
    
    func storeOverlayDidFailToLoad(_ overlay: SKOverlay, error: Error) {
        ZFPrint("error: \(error.localizedDescription)")
    }
}

