
//
//  CollectionDragViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2017/12/17.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit
import ZLPhotoBrowser

enum TransitionMethod {
    case zoom, page, halfPage, circle
}

private let reuseIdentifier = "DragAndDropCell"

class CollectionDragViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    private var myFlowLayout: UICollectionViewFlowLayout?
    private var dragIndexPath: IndexPath?
    private var transitionType: TransitionMethod = .zoom
    
    var selectCell: DragCollectionViewCell?
    
    private var cropImageView: UIImageView!
    
//    var collectionView: UICollectionView?
    fileprivate lazy var collectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout()
        let itemWidth = kMainScreenWidth/5
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 15, left: 12, bottom: 15, right: 12)
        myFlowLayout = flowLayout
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: kMainScreenHeight - statusBarHeight() - kNaviBarHeight), collectionViewLayout: flowLayout)
        collection.register(DragCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        if #available(iOS 11.0, *) {
            collection.dragDelegate = self
            collection.dropDelegate = self
            collection.dragInteractionEnabled = true
            collection.reorderingCadence = .immediate
            collection.isSpringLoaded =  true
        }
        
        return collection
    }()
    
    fileprivate lazy var dataSource: [UIImage] = {
        var dataArray = [UIImage]()
        for i in 0..<27 {
            var nameString = "thumb\(i)"
            
            if let image = UIImage(named: nameString) {
                dataArray.append(image)
            }
        }
        return dataArray
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = CommonFunction.createBarButtonItem(title: "Menu", target: self, action: #selector(rightButtonClick))
        
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureViews() {
        view.addSubview(collectionView)
        
        cropImageView = UIImageView()
        cropImageView.addTapGesture(target: self, action: #selector(imageClick))
        view.addSubview(cropImageView)
        
        cropImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - action
    @objc private func imageClick() {
        cropImageView.isHidden = true
    }
    
    @objc private func rightButtonClick() {
        let alertController = UIAlertController(title: "select transition", message: nil, preferredStyle: .actionSheet)
        let zoomAction = UIAlertAction(title: "zoom", style: .default) { _ in
            self.transitionType = .zoom
        }
        
        let pageAction = UIAlertAction(title: "page", style: .default) { _ in
            self.transitionType = .page
        }
        
        let halfPageAction = UIAlertAction(title: "halfPage", style: .default) { _ in
            self.transitionType = .halfPage
        }
        
        let circlelAction = UIAlertAction(title: "circle", style: .default) { _ in
            self.transitionType = .circle
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertController.addAction(zoomAction)
        alertController.addAction(pageAction)
        alertController.addAction(halfPageAction)
        alertController.addAction(circlelAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource,UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DragCollectionViewCell
        cell.targetImageView?.image = dataSource[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "select a menu", message: nil, preferredStyle: .actionSheet)
        let firAction = UIAlertAction(title: "image edit", style: .default) { _ in
            let image = self.dataSource[indexPath.item]
            self.imageEdit(image)
        }
        
        let secAction = UIAlertAction(title: "photo library", style: .default) { _ in
            self.showPhotoLibrary()
        }
        
        let thirdAction = UIAlertAction(title: "transition", style: .default) { _ in
            let cell = collectionView.cellForItem(at: indexPath) as! DragCollectionViewCell
            self.selectCell = cell
            let searchVC = CollectionDetailViewController()
            searchVC.imageView.image = cell.targetImageView.image

            self.zl_pushViewController(searchVC)
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertController.addAction(firAction)
        alertController.addAction(secAction)
        alertController.addAction(thirdAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func imageEdit(_ image: UIImage) {
        ZLPhotoConfiguration.default().editImageConfiguration.tools = [.draw, .clip, .textSticker, .mosaic]
        ZLEditImageViewController.showEditImageVC(parentVC: self, image: image) { resultImage, model in
            self.setupCropImage(resultImage)
        }
    }
    
    private func showPhotoLibrary() {
        ZLPhotoConfiguration.default().allowSelectVideo = false
        ZLPhotoConfiguration.default().saveNewImageAfterEdit = false
        ZLPhotoConfiguration.default().maxSelectCount = 5
        
        ZLPhotoConfiguration.default().editImageConfiguration.tools = [.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust]
        
        ZLPhotoConfiguration.default()
            .editImageConfiguration
            .imageStickerContainerView(ImageStickerContainerView())
        
        let ps = ZLPhotoPreviewSheet()
        ps.selectImageBlock = {[weak self] results, isOriginal in
            for model in results {
                ZFPrint("image size: \(model.image.size)")
            }
            
            if results.count == 1 {
                self?.setupCropImage(results[0].image)
            }
        }
        ps.showPhotoLibrary(sender: self)
    }
    
    private func setupCropImage(_ resultImage: UIImage) {
        self.cropImageView.image = resultImage
        self.cropImageView.snp.updateConstraints { make in
            make.size.equalTo(resultImage.size)
        }
        self.cropImageView.isHidden = false
    }
    
    // MARK: - UICollectionViewDragDelegate
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: dataSource[indexPath.item])
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragIndexPath = indexPath;
        return [dragItem]
    }
    
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: dataSource[indexPath.item])
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        let previewWidth = myFlowLayout?.itemSize.width
        parameters.visiblePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: previewWidth!, height: previewWidth!), cornerRadius: 5)
        
        return parameters
    }
    
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        
    }
    
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        
    }
    
    // MARK: - UICollectionViewDropDelegate
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath
        let tableDragItem = coordinator.items.first
        let dragItem = tableDragItem?.dragItem
        let image = dataSource[(dragIndexPath?.row)!];
        
//        if dragItem.itemProvider.canLoadObject(ofClass: UIImage.classForCoder() as! NSItemProviderReading.Type) {
//            dragItem.itemProvider.loadObject(ofClass: UIImage.classForCoder() as! NSItemProviderReading.Type, completionHandler: { (provider: NSItemProviderReading, nil) in -> Void
//
//                } as! (NSItemProviderReading?, Error?) -> Void)
//        }
        
        if dragIndexPath?.section == destinationIndexPath?.section && dragIndexPath?.row == destinationIndexPath?.row {
            return
        }
        
        collectionView.performBatchUpdates({
            // 目标 cell 换位置
            dataSource.remove(at: (dragIndexPath?.item)!)
            dataSource.insert(image, at: (destinationIndexPath?.item)!)
            collectionView.moveItem(at: dragIndexPath!, to: destinationIndexPath!)
        }) { (finished: Bool) in
            
        }
        
        coordinator.drop(dragItem!, toItemAt: destinationIndexPath!)
    }
    
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let dropProposal = UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        
        return dropProposal
    }
    
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if (session.localDragSession == nil) {
            return false
        }
        return true
    }
    
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return nil
    }
}

extension CollectionDragViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push && toVC.isKind(of: CollectionDetailViewController.self) {
            switch transitionType {
            case .zoom:
                return ZoomTransition(transType: .push)
            case .page:
                return PageTransition(transType: .push)
            case .halfPage:
                return HalfPageTransition(transType: .push)
            case .circle:
                return CircleTransition(transType: .push)
            }
        }
        
        if operation == .pop && fromVC.isKind(of: CollectionDetailViewController.self) {
            switch transitionType {
            case .zoom:
                return ZoomTransition(transType: .pop)
            case .page:
                return PageTransition(transType: .pop)
            case .halfPage:
                return HalfPageTransition(transType: .pop)
            case .circle:
                return CircleTransition(transType: .pop)
            }
        }
        
        return nil
    }
}
