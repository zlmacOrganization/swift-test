//
//  EmotionTableViewCell.swift
//  SwiftDemo
//
//  Created by bfgjs on 2019/2/27.
//  Copyright © 2019 bfgjs. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import HandyJSON

struct DynamicModel: HandyJSON {
    
    var content: String?
    var userHeadimg: String?
    var userNickName: String?
    var picList: [String]?
}

let headImageWidth = 40
let oneOrTwoWidth: CGFloat = (kMainScreenWidth - 30)/2
let threeOrFourWidth: CGFloat = (kMainScreenWidth - 40)/3

class EmotionTableViewCell: UITableViewCell {
    
    private var headImageView = UIImageView()
    private var nameLabel = UILabel()
    private var contentLabel = UILabel()
    private var collectionView: UICollectionView!
    
    var imageClickClosure: ((UIImageView, DynamicModel) -> Void)?
    
    var model: DynamicModel? {
        didSet {
            setImage(imageView: headImageView, urlString: model?.userHeadimg ?? "")
            nameLabel.text = model?.userNickName ?? ""
            contentLabel.text = model?.content ?? ""
            
            let count = model?.picList?.count ?? 0
            var bgViewHeight: CGFloat = 0
            
            if count > 0 && count <= 2 {
                bgViewHeight = oneOrTwoWidth
            }else if count == 3 {
                bgViewHeight = threeOrFourWidth
            }else if count == 4 {
                bgViewHeight = threeOrFourWidth*2 + 10
            }
            
            collectionView.snp.updateConstraints { (make) in
                make.height.equalTo(bgViewHeight)
            }
            
            collectionView.reloadData()
        }
    }
    
    private func setImage(imageView: UIImageView, urlString: String) {
        imageView.kf.setImage(with: URL(string: urlString), placeholder: UIImage(named: "man"), options: [.transition(.fade(0.3))], progressBlock: nil, completionHandler: nil)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(headImageView)
        headImageView.layer.cornerRadius = CGFloat(headImageWidth/2)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.zl_registerCell(EmotionCollectionCell.self)
        contentView.addSubview(collectionView)
        
        makeViewContraints()
    }
    
    private func makeViewContraints() {
        headImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: headImageWidth, height: headImageWidth))
            make.top.equalTo(10)
            make.left.equalTo(12)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView.snp.right).offset(10)
            make.centerY.equalTo(headImageView.snp.centerY)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(headImageView.snp.bottom).offset(14)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.height.equalTo(oneOrTwoWidth)
            make.bottom.equalToSuperview().offset(-12)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc private func imageViewClick(gesture: UITapGestureRecognizer) {
//        let clickImageView = gesture.view as! UIImageView
//        let picList = model?.picList ?? [String]()
        
//        if let closure = imageClickClosure {
//            closure(clickImageView, model ?? DynamicModel())
//        }
        
        //            var images = [SKPhoto]()
        //
        //            for urlString in picList {
        //                let photo = SKPhoto.photoWithImageURL(urlString)
        //                images.append(photo)
        //            }
        //
        //            let browser = SKPhotoBrowser(photos: images, initialPageIndex: clickImageView.tag)
        //            contentView.getCurrentViewController()?.present(browser, animated: true) {
        //
        //            }
    }
}

extension EmotionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.picList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.zl_dequeueReusableCell(EmotionCollectionCell.self, indexPath: indexPath)
        
        setImage(imageView: cell.publishImg, urlString: model?.picList?[indexPath.item] ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var photos = [AXPhoto]()
//        let picList = model?.picList ?? []
//        
//        for urlString in picList {
//            let axPhoto = AXPhoto.init(attributedTitle: NSAttributedString(string: ""), attributedDescription: NSAttributedString(string: ""), attributedCredit: NSAttributedString(string: ""), imageData: nil, image: nil, url: URL(string: urlString))
//            photos.append(axPhoto)
//        }
//        
//        let dataSource = AXPhotosDataSource(photos: photos, initialPhotoIndex: indexPath.item)
//        let photoController = AXPhotosViewController(dataSource: dataSource)
//        photoController.modalPresentationStyle = .fullScreen
//        contentView.getCurrentViewController()?.present(photoController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = model?.picList?.count ?? 0
        if count > 0 && count <= 2 {
            return CGSize(width: oneOrTwoWidth, height: oneOrTwoWidth)
        }else if count == 3 || count == 4 {
            return CGSize(width: threeOrFourWidth, height: threeOrFourWidth)
        }
        
        return CGSize.zero
    }
}

class EmotionCollectionCell: UICollectionViewCell {
    var publishImg: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        publishImg = UIImageView()
        publishImg.contentMode = .scaleAspectFill
        publishImg.clipsToBounds = true
        contentView.addSubview(publishImg)
        
        publishImg.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
