//
//  TableRefreshViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 16/12/12.
//  Copyright © 2016年 ZhangLiang. All rights reserved.
//

import UIKit
import PhotosUI
import VisionKit
import LocalAuthentication
import Vision
import TZImagePickerController

class TableRefreshViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var testId: String?
    
    var tableView: UITableView!
    var headerImage: UIImageView!
    var selectImage: UIImage?
    var allTimes = [String]()
    var refreshControl: UIRefreshControl?
    
    private var itemProviders = [NSItemProvider]()
    private var itemProvidersIterator: IndexingIterator<[NSItemProvider]>?
    private var currentItemProvider: NSItemProvider?
    
    private var livePhotoView: PHLivePhotoView? {
        didSet {
            livePhotoView?.contentMode = .scaleAspectFit
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = CommonFunction.createBarButtonItem(title: "Menu", target: self, action: #selector(rightButtonClick))

        allTimes.append(CommonFunction.getCurrentTimeString(format: "yyyy-MM-dd HH:mm:ss"))
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.zl_registerCell(UITableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 55
        tableView.tableFooterView = UIView(frame: .zero)
//            tableView.autoresizingMask = .flexibleWidth | .flexibleHeight
        
        refreshControl = UIRefreshControl()
//            refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshControl?.addTarget(self, action: #selector(handleRefresh(paramSender:)), for: .valueChanged)
        tableView.addSubview(refreshControl!)
//            theTableView.refreshControl = refreshControl
        
        view.addSubview(tableView)
        
        setTableHeaderView()
    }
    
    func setTableHeaderView() {
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
        
        headerImage = UIImageView(frame: CGRect(x: (screenWidth - 100)/2, y: 50, width: 100, height: 100))
        headerImage.image = Asset.man.image
        headerView.addTapGesture(target: self, action: #selector(imageClick))
        headerView.addSubview(headerImage)
        
//        if let data = "http://www.digitalbunker.dev".data(using: .ascii), let aztecBarcode = try? AztecBarcode(inputMessage: data) {
//            headerImage.image = BarcodeService.generateBarcode(from: aztecBarcode)
//        }
        
        if let data = "https://www.baidu.com".data(using: .ascii) {
            let qrCode = QRCode(inputMessage: data)
            headerImage.image = BarcodeService.generateBarcode(from: qrCode)
        }
        
        self.tableView.tableHeaderView = headerView
    }
    
//    @available(iOS 11.0, *)
//    override func viewSafeAreaInsetsDidChange() {
//        super.viewSafeAreaInsetsDidChange()
//
//        var insets = view.safeAreaInsets
//        insets.top = 0
//        tableView.contentInset = insets
//    }
    
    //MARK: - action
    @objc private func rightButtonClick() {
        let alertController = UIAlertController(title: "select a menu", message: nil, preferredStyle: .actionSheet)
        let docAction = UIAlertAction(title: "show document", style: .default) { _ in
            let types = ["public.content", "public.text", "public.source-code", "public.image", "public.folder", "public.directory", "public.audio", "public.movie", "public.png", "public.jpeg"]
//            let documentPickerVC = UIDocumentPickerViewController(documentTypes: types, in: .open)
//            documentPickerVC.delegate = self
//
//            self.zl_present(documentPickerVC)
            
            //["kUTTypePNG", "kUTTypeJPEG", "kUTTypePlainText", "kUTTypeText", "kUTTypeImage"]
            let browserVC = UIDocumentBrowserViewController(forOpeningFilesWithContentTypes: types)
            browserVC.delegate = self
//            browserVC.allowsDocumentCreation = false
//            browserVC.allowsPickingMultipleItems = false
//            self.zl_present(browserVC)
            self.present(browserVC, animated: true)
        }
        
        let modalAction = UIAlertAction(title: "modal", style: .default) { _ in
//            self.zl_present(UINavigationController(rootViewController: ModalViewController()))
            let vc = UINavigationController(rootViewController: SmallViewController())
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
        
        let searchAction = UIAlertAction(title: "pop", style: .default) { _ in
            self.headerImage.image?.detectQRCode(block: { observation in

            })
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertController.addAction(docAction)
        alertController.addAction(modalAction)
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleRefresh(paramSender: AnyObject)  {
//        self.refreshControl?.beginRefreshing()
        
        self.allTimes.append(CommonFunction.getCurrentTimeString(format: "yyyy-MM-dd HH:mm:ss"))
        let indexPathOfNewRow = NSIndexPath(row: self.allTimes.count - 1, section: 0)
        self.tableView.insertRows(at: [indexPathOfNewRow as IndexPath], with: .automatic)
        
        self.refreshControl?.endRefreshing()
    }
    
    @objc private func imageClick() {
//        if Bool.random()
        let alertController = UIAlertController(title: "select a menu", message: nil, preferredStyle: .actionSheet)
        let firAction = UIAlertAction(title: "指纹识别", style: .default) { _ in
            self.fingerAction()
        }
        
        let secAction = UIAlertAction(title: "文档扫描", style: .default) { _ in
            self.scanAction()
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertController.addAction(firAction)
        alertController.addAction(secAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func fingerAction() {
        let context = LAContext()
        context.localizedFallbackTitle = "输入密码"
        context.localizedCancelTitle = "取消"
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "验证") { success, error in
                if success {
                    //验证成功 放在主线程操作
                    switch context.biometryType {
                    case .faceID:
                        self.showNoticeOnlyText("faceID 验证成功")
                    case .none:
                        self.showNoticeOnlyText("none")
                    case .touchID:
                        self.showNoticeOnlyText("touchID 验证成功")
                    @unknown default:
                        self.showNoticeOnlyText("unknown")
                    }
                }else {
                    if let error = error as NSError? {
                        switch error.code {
                        case LAError.appCancel.rawValue:
                            self.showNoticeOnlyText("已取消")
                        case LAError.authenticationFailed.rawValue:
                            self.showNoticeOnlyText("验证失败")
                        case LAError.userCancel.rawValue:
                            self.showNoticeOnlyText("已取消")
                        case LAError.passcodeNotSet.rawValue:
                            self.showNoticeOnlyText("未设置密码")
                        case LAError.biometryLockout.rawValue:
                            self.showNoticeOnlyText("验证失败")
                        default:
                            self.showNoticeOnlyText("验证失败")
                            self.showNoticeOnlyText(error.description)
                        }
                    }
                }
            }
        }else {
            if #available(iOS 14.0, *) {
                let identifier = (try? URL(string: "local file")?.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier) ?? ""
                if UTType(identifier)?.supertypes.contains(.image) ?? false {
                    
                }
            }
            self.showNoticeOnlyText("不支持指纹")
        }
    }
    
    private func scanAction() {
        if #available(iOS 13.0, *), VNDocumentCameraViewController.isSupported {
            let cameraVC = VNDocumentCameraViewController()
            cameraVC.delegate = self
            present(cameraVC, animated: true, completion: nil)
        }else {
            self.showNoticeOnlyText("不支持扫描")
        }
    }
    
    //MARK: -
    deinit {
        ZFPrint("TableRefreshViewController deinit ++++")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = "\(allTimes[indexPath.row])"
//        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//        let shareAction = UITableViewRowAction(style: .default, title: "share", handler: {
//            (action: UITableViewRowAction, indexP: IndexPath) -> (Void) in
//            debugPrint("share click ++++")
//        })
//        shareAction.backgroundColor = UIColor.red
//        
//        let deleteAction = UITableViewRowAction(style: .default, title: "delete", handler: {
//            (action: UITableViewRowAction, indexP: IndexPath) -> (Void) in
//            debugPrint("delete click ++++")
//        })
//        deleteAction.backgroundColor = UIColor.lightGray
//        
//        let downAction = UITableViewRowAction(style: .normal, title: "download", handler: {
//            (action: UITableViewRowAction, indexP: IndexPath) -> (Void) in
//            debugPrint("download click ++++")
//        })
//        downAction.backgroundColor = UIColor.orange
//        
//        return [deleteAction, shareAction, downAction]
//    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal, title: "share") { (action, view, complete) in
            self.noticeOnlyText("share action")
            complete(true)
        }

        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, view, complete) in
            self.noticeOnlyText("delete action")
            complete(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [delete, share])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showImagePicker {[weak self] image in
            if let image = image {
                let markImage = image.addTextWatermark(text: "watermark", textColor: .red)
                self?.selectImage = markImage
                self?.headerImage?.image = markImage

//                if #available(iOS 13.0, *) {
//                    image.textRecognize { results in
//
//                    }
//                }
            }
        }
        
//        let imagePicker = TZImagePickerController(maxImagesCount: 10, delegate: self)
//        imagePicker?.allowPickingVideo = false
//        imagePicker?.showSelectBtn = true
//        imagePicker?.modalPresentationStyle = .fullScreen
//        imagePicker?.didFinishPickingPhotosHandle = { (photos, assets, isSelectOriginalPhoto) in
//
//        }
//
//        if let imagePicker = imagePicker {
//            zl_present(imagePicker)
//        }
    }
    
    @available(iOS 14, *)
    private func presentPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        zl_present(picker, animated: true)
    }
}

extension TableRefreshViewController: TZImagePickerControllerDelegate {
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

//MARK: - PHPickerViewControllerDelegate
@available(iOS 14.0, *)
extension TableRefreshViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if picker.configuration.selectionLimit > 1 {
            for pickerResult in results {
                let itemProvider = pickerResult.itemProvider
                
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                        
                        if let image = provider as? UIImage {
                            
                            DispatchQueue.main.async {
                                print(image.size)
                            }
                        }
                    }
                }
            }
        }else {
            guard let itemProvider = results.first?.itemProvider else { return }
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                    
                    if let image = provider as? UIImage {
                        
                        DispatchQueue.main.async {
                            self.selectImage = image
                            self.headerImage?.image = image
                        }
                    }
                }
            }
        }
        
//        itemProviders = results.map(\.itemProvider)
//        itemProvidersIterator = itemProviders.makeIterator()
//        displayNextImage()
    }
    
    private func displayNextImage() {
        guard let itemProvider = itemProvidersIterator?.next() else { return }
        currentItemProvider = itemProvider
        if itemProvider.canLoadObject(ofClass: PHLivePhoto.self) {
            itemProvider.loadObject(ofClass: PHLivePhoto.self) { [weak self] livePhoto, error in
                DispatchQueue.main.async {
                    guard let self = self, self.currentItemProvider == itemProvider else { return }
                    if let livePhoto = livePhoto as? PHLivePhoto {
                        self.display(livePhoto: livePhoto)
                    } else {
                        self.display(image: UIImage(systemName: "exclamationmark.circle"))
                        print("Couldn't load live photo with error: \(error?.localizedDescription ?? "unknown error")")
                   }
                }
            }
        } else if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self, self.currentItemProvider == itemProvider else { return }
                    if let image = image as? UIImage {
                        self.display(image: image)
                    } else {
                        self.display(image: UIImage(systemName: "exclamationmark.circle"))
                        print("Couldn't load image with error: \(error?.localizedDescription ?? "unknown error")")
                    }
                }
            }
        } else {
            print("Unsupported item provider: \(itemProvider)")
        }
    }
    
    private func display(livePhoto: PHLivePhoto? = nil, image: UIImage? = nil) {
        livePhotoView?.livePhoto = livePhoto
        livePhotoView?.isHidden = livePhoto == nil
        self.selectImage = image
        self.headerImage?.image = image
    }
}

//MARK: - VNDocumentCameraViewControllerDelegate
@available(iOS 13.0, *)
extension TableRefreshViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let image = scan.imageOfPage(at: 0)
        headerImage.image = image
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UIDocumentPickerDelegate
extension TableRefreshViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let firstUrl = urls.first else {return}
        
        let fileUrlAuthozied = firstUrl.startAccessingSecurityScopedResource()
        var error: NSError?
        
        if fileUrlAuthozied {
            let fileCoordinator = NSFileCoordinator()
            fileCoordinator.coordinate(readingItemAt: firstUrl, options: [.withoutChanges], error: &error) { newURL in
                
                if let fileData = try? Data(contentsOf: newURL, options: .mappedIfSafe) {
                    let fileName = newURL.lastPathComponent
                    let filePath = newURL.path.appending(fileName)
                    ZFPrint("filePath: \(filePath)")
                    if FileManager.default.fileExists(atPath: filePath) {
                        try? FileManager.default.removeItem(atPath: filePath)
                    }else {
                        try? fileData.write(to: URL(fileURLWithPath: filePath))
                    }
                }else {
                    ZFPrint("read file failed ++++")
                }
                
                controller.dismiss(animated: true, completion: nil)
            }
            firstUrl.stopAccessingSecurityScopedResource()
        }else {
            ZFPrint("Authozied failed ++++")
        }
    }
}

//MARK: - UIDocumentBrowserViewControllerDelegate
extension TableRefreshViewController: UIDocumentBrowserViewControllerDelegate {
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        if let firstUrl = documentURLs.first, firstUrl.startAccessingSecurityScopedResource() {
            do {
                let data = try Data(contentsOf: firstUrl)
                let jsonStr = String(data: data, encoding: .utf8)
                firstUrl.stopAccessingSecurityScopedResource()
                print(jsonStr ?? "empty str")
            } catch  {
                print("no data ++++")
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension TableRefreshViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class ModalViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: .light)
        let visualView = UIVisualEffectView(effect: blurEffect)
        visualView.frame = view.bounds
        visualView.alpha = 0.2
        visualView.backgroundColor = UIColor.black
        view.addSubview(visualView)
    }
    
    override var modalTransitionStyle: UIModalTransitionStyle {
        get {
            return .crossDissolve
        }
        
        set {
            super.modalTransitionStyle = newValue
        }
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            return .overCurrentContext
        }
        
        set {
            super.modalPresentationStyle = newValue
        }
    }
}
