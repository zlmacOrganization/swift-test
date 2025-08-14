//
//  MosaicViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 17/1/7.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class MosaicViewController: BaseViewController {
    
    var imageView = UIImageView()
    var myLabel: UILabel?
    var isUpdateConstrants: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        configureViews()
        makeContrastants()
        netRequest()
        
        addASAuthorization()
    }
    
    convenience init(name: String) {
        self.init()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureViews() {
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
//        imageView.image = UIImage(named: "man")
        let image = UIImage(named: "man")
        imageView.layer.contents = image?.cgImage
//        imageView.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        imageView.layer.contentsGravity = CALayerContentsGravity.resizeAspect
//        imageView.layer.magnificationFilter = kCAFilterNearest;
        CommonFunction.addTapGesture(with: imageView, target: self, action: #selector(imageCllickAction))
        view.addSubview(imageView)
        
        myLabel = UILabel()
        myLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(myLabel!)
        
        drawRectangle()
    }
    
    private func makeContrastants() {
//        let imageWidth = 200 as CGFloat
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(200)
            make.top.equalTo(80)
        }
        
        myLabel?.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.height.equalTo(24)
        }
    }
    
    func drawRectangle() {
        let width: CGFloat = 20
        let margin: CGFloat = (kMainScreenWidth - width*11 - 20)/10
        
        for i in 0..<12 {
            let height = CGFloat.random(in: 80..<120)
            
            let rectangleView = RectangleView(frame: CGRect(x: 10 + CGFloat(i)*(width + margin), y: 450 - height + 80, width: width, height: height))
            if i == 4 {
                rectangleView.bgColor = UIColor.darkGray
            }
            view.addSubview(rectangleView)
        }
    }
    
    @objc private func imageCllickAction() {
//        CommonFunction.startPraiseAnimation(with: imageView, fromValue: 1.0, toValue: 0.7, autoreverses: true, duration: 1.0, repeatCount: 1, fileMode: kCAFillModeForwards, keyType: "scaleAnimation")
        
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        isUpdateConstrants = !isUpdateConstrants
        
        if isUpdateConstrants {
            self.imageView.snp.updateConstraints { (make) in
                make.top.equalTo(80)
            }
        }else {
            self.imageView.snp.updateConstraints { (make) in
                make.top.equalTo(320)
            }
        }
    }
    
    func netRequest() {
        let parammeters: Parameters = ["userPhoneNum": "15926395764", "debug": "1"]
        
        pleaseWait()
        
        CommonNetRequest.new_get(urlString: CommonRequestUrl + "GetPromoServlet", parammeters: parammeters) { dict, error in
            self.clearAllNotice()
            
            if let dict = dict {
                let dataDict = dict["promo"] as! Dictionary<String, Any>
                
                if let model = CommonFunction.decodeModel(model: PromoModel.self, object: dataDict) {
                    self.imageView.kf.setImage(with: URL(string: model.url1), placeholder: UIImage(named: "man"), options: nil, progressBlock: nil, completionHandler: nil)
                    
                    if (model.addTime1.isEmpty) {
                        self.myLabel?.text = "myTestLabel"
                    }else{
                        setTimeWith(timeString: (model.addTime1.replacingOccurrences(of: ".0", with: "")), timeLabel: self.myLabel!)
                    }
                }
            }else {
                print("request error: \(error?.localizedDescription ?? "")")
            }
        }
    }

    private func addASAuthorization() {
        let signView = SignInView()
        view.addSubview(signView)
        
        signView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(60)
            make.size.equalTo(CGSize(width: 130, height: 40))
        }
    }
}
