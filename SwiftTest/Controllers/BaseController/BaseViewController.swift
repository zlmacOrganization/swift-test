//
//  BaseViewController.swift
//  SwiftTest
//
//  Created by lezhi on 2018/6/22.
//  Copyright © 2018年 ZhangLiang. All rights reserved.
//

import UIKit
import MobileCoreServices

class BaseViewController: UIViewController {
    
    private var backButton: UIButton!
    private var leftBarButtonItem: UIBarButtonItem!
    var finishPickingBlock: ((UIImage?) -> Void)?
    
    var leftImageName: String = "left_back" {
        didSet {
            backButton.setImage(UIImage(named: leftImageName), for: .normal)
//            navigationItem.leftBarButtonItem = CommonFunction.creatBarButtonItem(imageName: leftImageName, tintColor: UIColor.darkGray, target: self, action: #selector(baseBackButtonClick))
        }
    }
    
    var navBarHidden: Bool = false
    var navTranslucent: Bool = false {
        didSet {
            navigationController?.navigationBar.isTranslucent = navTranslucent
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }

    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        backButton = CommonFunction.createButton(frame: CGRect(x: 0, y: 0, width: 65, height: 44), title: nil, textColor: nil, font: nil, imageName: "left_back", isBackgroundImage: false, target: self, action: #selector(baseBackButtonClick))
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 15)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
//        navigationItem.leftBarButtonItem = CommonFunction.creatBarButtonItem(imageName: "left_back", tintColor: UIColor.darkGray, target: self, action: #selector(baseBackButtonClick))
        
        navigationController?.navigationBar.barTintColor = UIColor.dynamicColor(light: UIColor.white, dark: UIColor.black)
        
        setNavigationBar(UIColor.white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(navBarHidden, animated: true)
    }
    
//    @available(*, unavailable, message: "Unsupported init(coder:)")
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func baseBackButtonClick() {
        back()
    }
    
    func setNavigationBar(_ color: UIColor) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            if navTranslucent {
                appearance.configureWithOpaqueBackground()
            }else {
                appearance.configureWithTransparentBackground()
            }
            
            appearance.backgroundColor = color
            appearance.shadowColor = nil
//            appearance.titleTextAttributes = [
//                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
//                       NSAttributedString.Key.foregroundColor: UIColor.white
//                 ]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    func getNavBarAndStatusBarHeight() -> CGFloat {
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
        let barHeight = navigationController?.navigationBar.frame.height ?? 44
        
        return statusHeight + barHeight
    }
    
    //MARK: - image picker
    func showImagePicker(_ finishBlock: ((UIImage?) -> Void)? = nil) {
        let alertController = UIAlertController(title: "Choose", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let photoAction = UIAlertAction(title: "从相册选择", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction) -> Void in
            
            CommonFunction.photoAuthorization(isAllow: {
                self.pickerImageFormSource(sourceType: .photoLibrary, finishBlock)
            }, notAllow: {
                CommonFunction.showAlertController(title: "提示", message: "未开启相册权限", controller: self, cancelAction: nil, sureAction: {
                    CommonFunction.goSystemSetting()
                })
            }) {
                self.pickerImageFormSource(sourceType: .photoLibrary, finishBlock)
            }
        })
        
        let cameraAction = UIAlertAction(title: "拍照", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction) -> Void in
            if Platform.isSimulator {
                let alertController = UIAlertController(title: nil, message: "模拟器不支持拍照", preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.cancel, handler: nil)
                alertController.addAction(cancelAction)

                self.present(alertController, animated: true, completion: nil)
            }else{
                CommonFunction.photoAuthorization(isAllow: {
                    self.pickerImageFormSource(sourceType: .camera, finishBlock)
                }, notAllow: {
                    CommonFunction.showAlertController(title: "提示", message: "未开启相机权限", controller: self, cancelAction: nil, sureAction: {
                        CommonFunction.goSystemSetting()
                    })
                })
            }
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(photoAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func pickerImageFormSource(sourceType: UIImagePickerController.SourceType, _ finishBlock: ((UIImage?) -> Void)? = nil) {
        self.finishPickingBlock = finishBlock
//        let mediaTypes = UIImagePickerController.availableMediaTypes(for: sourceType)
        
//        if let mediaTypes = mediaTypes, UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let pickerController = UIImagePickerController()
//            pickerController.mediaTypes = mediaTypes
            pickerController.delegate = self
//            pickerController.allowsEditing = true
            pickerController.sourceType = sourceType
            pickerController.modalPresentationStyle = .fullScreen
            
            self.present(pickerController, animated: true, completion: nil)
//        }
    }
    
    func shrinkImage(originaImage: UIImage, size: CGSize) -> (UIImage) {
        UIGraphicsBeginImageContext(size)
        originaImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let finalImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return finalImage
    }
}

extension BaseViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chooseMediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if chooseMediaType == kUTTypeImage as String {
                let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                finishPickingBlock?(image)
                if let image = image {
                    ZFPrint("image size: \(image.size)")
                }
            }
        }
        
        picker.dismiss(animated: true, completion: {
            
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {
            
        })
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        //隐藏导航栏时切换页面出现黑条
        let isViewController = viewController.isKind(of: BaseViewController.self)
        navigationController.setNavigationBarHidden(isViewController, animated: true)
    }
}
