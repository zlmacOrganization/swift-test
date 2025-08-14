//
//  ThumbnailViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/9/3.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit
import PDFKit

protocol ThumbnailViewControllerDelegate: AnyObject {
    func didSelect(at item: Int)
}

class ThumbnailViewController: BaseViewController {
    var pdfDocument: PDFDocument?
    weak var delegate: ThumbnailViewControllerDelegate?
    
    private var collectionView: UICollectionView!
    private let queue = DispatchQueue(label: "zl.pdf.thumb", attributes: .concurrent)
    private let imageCache = NSCache<AnyObject, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "thumbnail"
        configureViews()
    }
    
    private func configureViews() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let width = (kMainScreenWidth - 40)/3
        layout.itemSize = CGSize(width: width, height: width*1.5)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.zl_registerCell(ThumbnailCollectionCell.self)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ThumbnailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pdfDocument?.pageCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.zl_dequeueReusableCell(ThumbnailCollectionCell.self, indexPath: indexPath)
        
        let page = pdfDocument?.page(at: indexPath.item)
        cell.pageLabel.text = page?.label
        
        let cacheKey = "key_\(indexPath.item)" as AnyObject
        if let thumbImage = imageCache.object(forKey: cacheKey) {
            cell.thumbImageView.image = thumbImage
        }else {
            let imageSize = CGSize(width: cell.zl_width*2, height: cell.zl_height*2)
            queue.async {
                if let thumbnailImage = page?.thumbnail(of: imageSize, for: .mediaBox) {
                    self.imageCache.setObject(thumbnailImage, forKey: cacheKey)
                    
                    DispatchQueue.main.async {
                        cell.thumbImageView.image = thumbnailImage
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.didSelect(at: indexPath.item)
            back()
        }
    }
}

class ThumbnailCollectionCell: UICollectionViewCell {
    var thumbImageView: UIImageView!
    var pageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        thumbImageView = UIImageView()
        contentView.addSubview(thumbImageView)
        
        pageLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 14), text: "", textColor: .darkGray, textAlignment: .center)
        contentView.addSubview(pageLabel)
        
        thumbImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-4)
            make.centerX.equalToSuperview()
        }
    }
}
