//
//  OtherViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/3/3.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit
import TZImagePickerController

class OtherViewController: BaseViewController {
    private var arrowImageView: UIImageView!
    private var buttonView: UIView!
    private var animateView = UIView()
    private var sfImageView: UIImageView!
    private var scaleCollectionView: UICollectionView!
    private var emojiCollectionView: UICollectionView!
    private var emojis: [EmojiModel] = []
    private var pageControl: UIPageControl!
    
    private var isUp: Bool = false
    private var isShow: Bool = false
    private var rotateAngle: CGFloat = 0
    private var angle : CGFloat = 0.0
    
    private var imageNames: [String] = []
    private var photos: [UIImage] = []
    
    private let items: [(icon: String, color: UIColor)] = [
        ("icon_home", UIColor(red: 0.19, green: 0.57, blue: 1, alpha: 1)),
        ("icon_search", UIColor(red: 0.22, green: 0.74, blue: 0, alpha: 1)),
        ("notifications-btn", UIColor(red: 0.96, green: 0.23, blue: 0.21, alpha: 1)),
        ("settings-btn", UIColor(red: 0.51, green: 0.15, blue: 1, alpha: 1)),
        ("nearby-btn", UIColor(red: 1, green: 0.39, blue: 0, alpha: 1))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView() {
        setTopView()
        configureCollectionView()
        addReplicatorView()
        setupEmojiView()
        setupPageControl()
    }
    
    private func setTopView() {
        let circleMenu = CircleMenu(frame: CGRect(x: (kMainScreenWidth - 80)/2, y: 100, width: 80, height: 40), normalIcon: "browser_share", selectedIcon: nil)
        circleMenu.buttonsCount = 5
//        circleMenu.distance = 110
        circleMenu.subButtonsRadius = 25
        circleMenu.delegate = self
        view.addSubview(circleMenu)
        
//        button.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(80)
//        }

        arrowImageView = UIImageView(image: UIImage(named: "filter_arrow_down"))
        CommonFunction.addTapGesture(with: arrowImageView, target: self, action: #selector(imageClick))
        view.addSubview(arrowImageView)
        
        arrowImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(circleMenu.snp.bottom).offset(25)
            make.size.equalTo(CGSize(width: 40, height: 30))
        }
        
        buttonView = UIView()
        buttonView.isHidden = true
        buttonView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        CommonFunction.addTapGesture(with: buttonView, target: self, action: #selector(buttonClick))
        view.addSubview(buttonView)
        
        buttonView.snp.makeConstraints { (make) in
            make.center.equalTo(circleMenu.snp.center)
            make.width.height.equalTo(120)
        }
    }
    
    private func configureCollectionView() {
        for i in 0..<27 {
            let name = "thumb\(i)"
            imageNames.append(name)
        }
        
        let layout = ScaleCollectionLayout()
        layout.isZoom = true
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        
        scaleCollectionView = UICollectionView(frame: CGRect(x: 0, y: 230, width: kMainScreenWidth, height: 100), collectionViewLayout: layout)
        scaleCollectionView.delegate = self
        scaleCollectionView.dataSource = self
        scaleCollectionView.backgroundColor = .white
        scaleCollectionView.zl_registerCell(ScaleCollectionCell.self)
        view.addSubview(scaleCollectionView)
    }
    
    private func setupCircleButtons(button: UIButton) {
        let circleWidth: CGFloat = 130
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.frame = CGRect(x: (kMainScreenWidth - circleWidth)/2, y: 40, width: circleWidth, height: circleWidth)
//        shapeLayer.lineWidth = 2
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeColor = UIColor.red.cgColor
//
//        let bezier = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: circleWidth, height: circleWidth))
////        bezier.addArc(withCenter: button.center, radius: 100, startAngle: 0.0, endAngle: CGFloat.pi*2, clockwise: true)
////        bezier.lineWidth = 2
////        UIColor.red.setStroke()
//        shapeLayer.path = bezier.cgPath
//
//        buttonView.layer.addSublayer(shapeLayer)
        
        let angles: [CGFloat] = [90.0, 180.0, 270.0, 360.0]
//        let angles: [CGFloat] = [72.0, 144.0, 216.0, 288.0, 360.0]
//        let angles: [CGFloat] = [60.0, 120.0, 180.0, 240.0, 300.0, 360.0]
        
        for i in 0..<angles.count {
            let angle = angles[i]
            let point = calculateCirclePoint(center: button.center, angle: angle, radius: circleWidth/2)
            let btn = CommonFunction.createButton(frame: CGRect(x: point.x - 20, y: point.y - 20, width: 40, height: 40), title: "\(i + 1)", textColor: UIColor.white, font: UIFont.systemFont(ofSize: 15), imageName: nil, target: self, action: #selector(buttonClick))
            btn.backgroundColor = UIColor.red
            btn.layer.cornerRadius = 20
            btn.clipsToBounds = true
            buttonView.addSubview(btn)
        }
    }
    
    private func addReplicatorView() {
        sfImageView = UIImageView()
        view.addSubview(sfImageView)
        
        sfImageView.snp.makeConstraints { make in
            make.top.equalTo(190)
            make.right.equalTo(-10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        if #available(iOS 13.0, *) {
            let image = UIImage(systemName: "battery.100.bolt")
            sfImageView.image = image
            sfImageView.tintColor = .purple

//            if #available(iOS 15.0, *) {
////                let config = UIImage.SymbolConfiguration(paletteColors: [.red, .purple, .orange])
//                let config = UIImage.SymbolConfiguration.preferringMulticolor()
//                sfImageView.preferredSymbolConfiguration = config
//            }
        }
    }
    
    private func setupEmojiView() {
        //左右分页滑动
//        let layout = HorizonPagableLayout(column: 6, row: 6)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let itemWidth = kMainScreenWidth/7
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        emojiCollectionView.backgroundColor = .white
        emojiCollectionView.zl_registerCell(EmojiCollectionCell.self)
        view.addSubview(emojiCollectionView)
        
        emojiCollectionView.snp.makeConstraints { make in
            make.top.equalTo(340)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-iphoneXBottomMargin)
//            make.height.equalTo(kMainScreenWidth/2)
        }
        
        let urlString = "https://emoji-api.com/emojis?search=flag&access_key=acd89c451b81a3b1d34630f9d281aa8a7f50c284"
        /*
         https://emoji-api.com/emojis?search=computer&access_key=
         https://emoji-api.com/emojis/grinning-squinting-face?access_key=
         https://emoji-api.com/categories?access_key=
         https://emoji-api.com/categories/travel-places?access_key=
         */
        CommonNetRequest.new_getJson(urlString: urlString, parammeters: nil) { response, error in
            if let results = response, let datas = CommonFunction.decodeArray(EmojiModel.self, object: results) {
                self.emojis = datas
                self.emojiCollectionView.reloadData()
            }
        }
    }
    
    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = emojis.count / 8 + (emojis.count % 8 == 0 ? 0 : 1)
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .purple
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(emojiCollectionView.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 20))
        }
    }
    
    //MARK: -
    private func replicatorLayer() -> CALayer {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 10, height: 80)
        layer.backgroundColor = UIColor.red.cgColor
        layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        layer.add(scaleYAnimation(), forKey: "scaleAnimation")
        
        let repLayer = CAReplicatorLayer()
        repLayer.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        repLayer.instanceCount = 8
        repLayer.instanceTransform = CATransform3DMakeTranslation(45, 0, 0)
        repLayer.instanceDelay = 0.4
        repLayer.instanceGreenOffset = -0.3
        
        repLayer.addSublayer(layer)
        
        return repLayer
    }
    
    private func scaleYAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale.y")
        animation.toValue = 0.1
        animation.duration = 0.4
        animation.repeatCount = MAXFLOAT
        animation.autoreverses = true
        return animation
    }
    
    @objc private func showAnimateView(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        self.angle -= .pi/2
        
        UIView.animate(withDuration: 0.25) {
//            sender.layer.transform = CATransform3DMakeRotation(self.angle, 0, 0, 1)
        }
    }
    
    @objc private func imageClick() {
        isUp.toggle()
        
        if isUp {
            UIView.animate(withDuration: 0.3) {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.arrowImageView.transform = .identity
            }
        }
        
        let imagePicker = TZImagePickerController(maxImagesCount: 10, delegate: self)
        imagePicker?.allowPickingVideo = false
        imagePicker?.showSelectBtn = true
        imagePicker?.photoWidth = 1080
        imagePicker?.photoPreviewMaxWidth = 828
        imagePicker?.modalPresentationStyle = .fullScreen
        imagePicker?.didFinishPickingPhotosHandle = {[weak self] (photos, assets, isSelectOriginalPhoto) in
            if let photos = photos {
                self?.photos += photos
                self?.scaleCollectionView.reloadData()
            }
        }

        if let imagePicker = imagePicker {
            zl_present(imagePicker)
        }
    }
    
    @objc private func buttonClick() {
//        buttonView.isHidden.toggle()
//        buttonView.isHidden = false
        isShow.toggle()
        
//        rotateAngle += CGFloat.pi*0.25
//        if isShow {
//            UIView.animate(withDuration: 0.5) {
//                self.buttonView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//    //            self.buttonView.layer.transform = CATransform3DMakeRotation(self.rotateAngle, 0, 0, 0.1)
//            }
//        } else {
//            buttonView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//            UIView.animate(withDuration: 0.5) {
//                self.buttonView.transform = CGAffineTransform(scaleX: 1, y: 1)
//    //            self.buttonView.layer.transform = CATransform3DMakeRotation(self.rotateAngle, 0, 0, 0.1)
//            }
//        }
        
    }
}

extension OtherViewController: TZImagePickerControllerDelegate {
    private func calculateCirclePoint(center: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint {
        let sf = angle*(CGFloat.pi)/180
        let cos = CGFloat(cosf(Float(sf)))
        let x = radius * cos
        
        let inf = angle*(CGFloat.pi)/180
        let sin = CGFloat(sinf(Float(inf)))
        let y = radius * sin
        
        return CGPoint(x: center.x + x, y: center.y - y)
    }
}

extension OtherViewController: CircleMenuDelegate {
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
//        let images = ["fb_share", "qq_share", "twitter_share", "weibo_share", "wx_share"]
//        button.setImage(UIImage(named: images[atIndex]), for: .normal)
//        button.backgroundColor = UIColor.clear
        
        button.backgroundColor = items[atIndex].color
        button.setImage(UIImage(named: items[atIndex].icon), for: .normal)

        let highlightedImage = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        
    }
}

extension OtherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emojis.count
        }else {
            return imageNames.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.zl_dequeueReusableCell(EmojiCollectionCell.self, indexPath: indexPath)
            cell.emojiLabel.text = emojis[indexPath.item].character
            
            return cell
        }else {
            let cell = collectionView.zl_dequeueReusableCell(ScaleCollectionCell.self, indexPath: indexPath)
            cell.setImageName(imageNames[indexPath.item])
//            cell.setupImage(photos[indexPath.item])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            
        }else {
            let testVC = TestViewController()
            navigationController?.pushViewController(testVC, animated: true)
        }
    }
}

extension OtherViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let page = contentOffset / scrollView.frame.size.width + (Int(contentOffset) % Int(scrollView.frame.size.width) == 0 ? 0 : 1)
        pageControl.currentPage = Int(page)
    }
}

class EmojiCollectionCell: UICollectionViewCell {
    var emojiLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emojiLabel = CommonFunction.createLabel(frame: .zero, text: "", font: UIFont.systemFont(ofSize: 15), textColor: .darkGray, textAlignment: .center)
        contentView.addSubview(emojiLabel)
        
        emojiLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct EmojiModel: Codable {
    var slug: String = ""
    var character: String = ""
    var unicodeName: String = ""
    var codePoint: String = ""
    var group: String = ""
    var subGroup: String = ""
}
