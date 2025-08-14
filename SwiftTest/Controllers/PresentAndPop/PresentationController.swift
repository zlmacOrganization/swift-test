//
//  PresentationController.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/9/8.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit
import AVFoundation

class PresentationController: UIPresentationController {
    private var visualView: UIVisualEffectView!
    
    override func presentationTransitionWillBegin() {
        let blurEffect = UIBlurEffect(style: .light)
        visualView = UIVisualEffectView(effect: blurEffect)
        visualView.frame = containerView?.bounds ?? CGRect(x: 0, y: 0, width: kMainScreenWidth, height: kMainScreenHeight)
        visualView.alpha = 0.2
        visualView.backgroundColor = UIColor.black
        containerView?.addSubview(visualView)
        visualView.addTapGesture(target: self, action: #selector(dismissVC))
    }
    
    @objc private func dismissVC() {
        presentedView?.getCurrentViewController()?.dismiss(animated: true)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            visualView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        visualView.alpha = 0
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            visualView.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            let frame = CGRect(x: 0, y: kMainScreenHeight - 400, width: kMainScreenWidth, height: 400)
            presentedView?.frame = frame
            return presentedView?.frame ?? frame
        }
        
        set {
            super.presentedView?.frame = newValue
        }
    }
}

class PopoverVC: UIViewController {
    var clickBlock: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor.colorWith(r: 245, g: 245, b: 245)
        
        let viewHeight: CGFloat = 45
        let names = ["change", "two", "three"]
        
        for (i, name) in names.enumerated() {
            let button = CommonFunction.createButton(frame: CGRect(x: 5, y: 15 + CGFloat(i)*viewHeight, width: 60, height: viewHeight), title: name, textColor: UIColor.darkGray, font: UIFont.systemFont(ofSize: 14), target: self, action: #selector(buttonClick(_:)))
            button.tag = i
            view.addSubview(button)
        }
        
//        navigationItem.rightBarButtonItem = CommonFunction.createBarButtonItem(title: "present", target: self, action: #selector(rightButtonClick))
    }
    
    @objc private func buttonClick(_ button: UIButton) {
        clickBlock?(button.tag)
        dismiss(animated: true)
    }
}

class TestViewController: BaseViewController {
    private var tableView: UITableView!
    private var rowCount = 40
    private var synthesizer: AVSpeechSynthesizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = editButtonItem
        configureViews()
        
        if #available(iOS 12.0, *) {
            NetworkMonitor.shared.startMonitoring()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(networkChanged), name: .connectivityStatus, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if #available(iOS 12.0, *) {
            NetworkMonitor.shared.stopMonitoring()
        }
        stop()
    }
    
    @objc func networkChanged() {
        if #available(iOS 12.0, *) {
            if NetworkMonitor.shared.isConnected {
                print("net: \(NetworkMonitor.shared.connectionType ?? .other)")
            }else {
                print("Not connected ++++")
            }
        }
    }
    
    private func configureViews() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.zl_registerCell(UITableViewCell.self)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func rightItemClick() {
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: animated)

        if !editing {
            if let indexPaths = tableView.indexPathsForSelectedRows {
                for path in indexPaths {
                    print("row: \(path.row)")
                }
            }
        }
    }
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = "item\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
//        setEditing(true, animated: true)
    }
    
    func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//
//        if let synthesizer = self.synthesizer {
//            if synthesizer.isPaused {
//                synthesizer.continueSpeaking()
//            }else {
//                pause()
//            }
//        }else {
//            play()
//        }
//    }
    
    //MARK: - AVSpeechSynthesizer
    private func play() {
        let utterance = AVSpeechUtterance(string: "哈哈，你是个傻子，ZFPlayer是对AVPlayer的封装，有人会问它支持什么格式的视频播放，问这个问题的可以自行搜索AVPlayer支持的格式")
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = 0.5
        utterance.volume = 1.0
        utterance.postUtteranceDelay = 0.2
        
        synthesizer = AVSpeechSynthesizer()
        synthesizer?.speak(utterance)
    }
    
    private func pause() {
        synthesizer?.pauseSpeaking(at: .immediate)
    }
    
    private func stop() {
        synthesizer?.stopSpeaking(at: .word)
    }
}
