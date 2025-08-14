//
//  ActivityViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2017/7/9.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit
import StoreKit
import SnapKit
//import SwiftProgressHUD
//import RxSwift
//import RxCocoa

class DiffableTestController: BaseViewController {
    
    var textField: UITextField!
    var buttonShare: UIButton!
    var textView: UITextView?
//    let disposeBag = DisposeBag()
    
//    override func loadView() {
//        let scrollView = UIScrollView()
//        scrollView.keyboardDismissMode = .interactive
//        scrollView.alwaysBounceVertical = true
//        scrollView.backgroundColor = UIColor.white
//        self.view = scrollView
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

//        dbTest()
        creatTextField()
//        becomeFirstResponder()
        creatShareButton()
        addKeyboardNotification()
    }
    
    deinit {
        print("ActivityViewController deinit ++++")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureMyButton() {
        let width = 70 as CGFloat
        
        let button = UIButton()
        button.snp.makeConstraints { (make) in
            make.size.width.equalTo(width)
            make.size.height.equalTo(40)
            make.center.equalTo(view)
        }
        button .setTitle("Click", for: UIControl.State.normal)
        button.setTitleColor(UIColor.purple, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(myButtonClick), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button)
    }
    
    func dbTest() {
        let manager = DBManager()
        manager.creatTable()
        manager.insertUser(userId: 1111, name: "user 1", age: 23)
        manager.insertUser(userId: 1112, name: "user 2", age: 24)
        
        manager.updateUser(userId: 1112, userName: "user 2", age: 27)
    }

    @objc func myButtonClick() {
        showShareActivity(content: "share test")
    }
    
    func creatTextField()  {
        
        textField = UITextField(frame: CGRect(x: 30, y: 40, width: kMainScreenWidth - 30*2, height: 30))
        textField.borderStyle = .roundedRect
        textField.placeholder = CommonFunction.localizedString(originString: "Enter text to share...")
        textField.layer.borderWidth = 1;
        textField.layer.borderColor = UIColor.lightGray.cgColor
//        textField.delegate = self
        view.addSubview(textField)
    }
    
    func creatShareButton() {
        buttonShare = UIButton(frame: CGRect(x: (kMainScreenWidth - 200)/2, y: 100, width: 200, height: 40))
        buttonShare.setTitle(CommonFunction.localizedString(originString: "Share"), for: .normal)
        buttonShare.setTitleColor(UIColor.red, for: .normal)
        buttonShare.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        buttonShare.addTarget(self, action: #selector(DiffableTestController.handleShare), for: .touchUpInside)
//        buttonShare.rx.tap.subscribe(onNext: {[weak self] _ in
//            self?.handleShare()
//        }).disposed(by: disposeBag)
        view.addSubview(buttonShare)
    }
    
//    override var canBecomeFirstResponder: Bool { true }
//    override var inputAccessoryView: UIView? { textField }
    
    @objc func handleShare()  {
        textField.resignFirstResponder()
        textView?.resignFirstResponder()
        
        if (textField.text?.isEmpty)! {
            let message = CommonFunction.localizedString(originString: "Please enter a text and then press Share")
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            return
        }
        
        if Platform.isSimulator {
            showShareActivity(content: textField.text!)
        }else {
            
        }
    }
    
    func creatTextView()  {
        textView = UITextView(frame: CGRect(x: 40, y: 240, width: 100, height: 60))
        textView?.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        textView?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(textView!)
    }
    
    func showShareActivity(content: String) {
        let image = UIImage(named: "weibo_share")!
        let shareUrl = URL(string: "http://www.ningmengxinli.com/expertDetail.html?expertId=151&from=share")!
        let shareContent = "\(content) \(shareUrl)"
        
        let activityController = UIActivityViewController(activityItems: [shareContent, image, shareUrl], applicationActivities: nil)
//                activityController.excludedActivityTypes = [UIActivityType.postToWeibo, UIActivityType.postToFacebook, UIActivityType.postToTwitter]
        activityController.completionWithItemsHandler = {
            (type, complete, returnedItems, error) in
            if complete {
                self.showShareResult(result: "share success!")
            }else{
                self.showShareResult(result: "failed")
            }
        }
        
        self.present(activityController, animated: true, completion: nil)
    }
    
    func showShareResult(result: String) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            SwiftProgressHUD.showOnlyText(result)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                SwiftProgressHUD.hideAllHUD()
//            }
//        }
    }
    
    //MARK: - keyboard notification
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(DiffableTestController.handleKeyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DiffableTestController.handleKeyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
//    NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardDidShow).subscribe(onNext: { (notify) in
//            print("KeyboardDidShow ++++")
//        }).disposed(by: disposeBag)
    }
    
    @objc func handleKeyboardDidShow(notification: NSNotification) {
        
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
        textView?.resignFirstResponder()
    }

}

extension DiffableTestController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismiss(animated: true, completion: nil)
    }
}
