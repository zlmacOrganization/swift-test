//
//  AnimateViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2017/10/28.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import MediaPlayer
import AudioToolbox
import Speech
import PDFKit

 private enum State {
    case expanded
    case collapsed
}

private prefix func !(_ state: State) -> State {
    return state == State.expanded ? .collapsed : .expanded
}

class AnimateViewController: BaseViewController {
    private var pageContentView: ZLPageContentView!
    private var titleView: ZLSegmentTitleView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let menuItem = UIBarButtonItem(title: "PDF", style: .plain, target: self, action: #selector(rightButtonItemClick))
        navigationItem.rightBarButtonItem = menuItem
        
        configureSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureSubviews() {
        let titles = ["体育奥运", "时尚", "经济学经济经济学经济", "军事历史", "汽车科技", "娱乐娱乐", "汽车科技", "娱乐娱乐"]
        titleView = ZLSegmentTitleView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: 40), titles: titles, delegate: self)
        view.addSubview(titleView)
        
        
        var childs: [UIViewController] = []
        for _ in 0..<titles.count {
            let controller = SubViewController()
//            controller.view.backgroundColor = CommonFunction.randomColor()
            childs.append(controller)
        }
        pageContentView = ZLPageContentView(frame: CGRect(x: 0, y: 40, width: kMainScreenWidth, height: kMainScreenHeight - 40), childVCs: childs, parentVC: self, delegate: self)
        view.addSubview(pageContentView)
    }
    
    @objc private func rightButtonItemClick() {
        let pdfVC = PDFViewController()
        navigationController?.pushViewController(pdfVC, animated: true)
    }
}

extension AnimateViewController: ZLSegmentTitleViewDelegate {
    func zlSegmentTitleView(titleView: ZLSegmentTitleView, startIndex: Int, endIndex: Int) {
        pageContentView.currentIndex = endIndex
    }
    
    func zlSegmentTitleViewWillBeginDragging() {
        
    }
    
    func zlSegmentTitleViewWillEndDragging() {
        
    }
}

extension AnimateViewController: ZLPageContentDelegate {
    func zlContentViewWillBeginDragging() {
        
    }
    
    func zlContentViewDidScroll(contentView: ZLPageContentView, startIndex: Int, endIndex: Int, progress: CGFloat, scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / scrollView.frame.size.width
        titleView.resetIndicatorFrame(progress: progress, offset: scrollView.contentOffset)
    }
    
    func zlContenViewDidEndDecelerating(contentView: ZLPageContentView, startIndex: Int, endIndex: Int) {
        titleView.selectIndex = endIndex
    }
    
    func zlContenViewDidEndDragging() {
        
    }
}

class SubViewController: UIViewController {
//    private let myQueue = DispatchQueue(label: "popView_test")
    private let audioUrl = "http://ningmengxinli.com/files/Tap/tap20180625135351331.mp3"

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isPlaying: Bool = true
    
    private var detailModel: TapDetailModel?
    
    private var radioImageView: UIImageView!
    private var recordButton: UIButton!
    private var resultLabel: UILabel!
    
//    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh_CN"))
//    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
//    private var recognitionTask: SFSpeechRecognitionTask?
//    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        tapDetailRequest()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: .event_remoteControlPlay, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: .event_remoteControlPause, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        speechAuthorization()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UIApplication.shared.endReceivingRemoteControlEvents()
//
//        if player != nil {
//            player?.pause()
//            playerLayer = nil
//            player = nil
//        }
    }
    
    private func speechAuthorization() {
//        SFSpeechRecognizer.requestAuthorization { authStatus in
//
//            // Divert to the app's main thread so that the UI
//            // can be updated.
//            OperationQueue.main.addOperation {
//                switch authStatus {
//                case .authorized:
//                    self.recordButton.isEnabled = true
//
//                case .denied:
//                    self.recordButton.isEnabled = false
//                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
//
//                case .restricted:
//                    self.recordButton.isEnabled = false
//                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
//
//                case .notDetermined:
//                    self.recordButton.isEnabled = false
//                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
//
//                default:
//                    self.recordButton.isEnabled = false
//                }
//            }
//        }
    }
    
    private func tapDetailRequest() {
        let param: Parameters = ["userPhoneNum": "15926395764", "tapId": "1295", "debug": "1"]
        CommonNetRequest.get(urlString: "\(CommonRequestUrl)tap/getTapDetailM", parammeters: param) { isOK, codeString, dict in
            if let model = CommonFunction.decodeModel(model: TapDetailModel.self, object: dict) {
                self.detailModel = model
                self.radioImageView.kf.setImage(with: URL(string: model.tap.picture))
            }
        } failure: { error in
            self.noticeOnlyText(error.localizedDescription)
        }
    }
    
    //MARK: -
    private func setupViews() {
        radioImageView = UIImageView()
        //http://ningmengxinli.com/files/Tap/tap20180625135350032.jpg
        CommonFunction.addTapGesture(with: radioImageView, target: self, action: #selector(clickAction))
        view.addSubview(radioImageView)
        
        radioImageView.snp.makeConstraints { make in
            make.top.equalTo(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
//        setupLayer()
        
//        recordButton = CommonFunction.createButton(frame: CGRect.zero, title: "start speech", textColor: UIColor.purple, font: UIFont.systemFont(ofSize: 15), target: self, action: #selector(recordButtonTapped))
//        // Disable the record buttons until authorization has been granted.
//        recordButton.isEnabled = false
//        view.addSubview(recordButton)
//        
//        recordButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(radioImageView.snp.bottom).offset(30)
//            make.size.equalTo(CGSize(width: 90, height: 40))
//        }
//        
//        resultLabel = CommonFunction.createLabel(font: UIFont.systemFont(ofSize: 15), text: "", textColor: UIColor.red, textAlignment: .center)
//        view.addSubview(resultLabel)
//        
//        resultLabel.snp.makeConstraints { make in
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
//            make.top.equalTo(recordButton.snp.bottom).offset(15)
//        }
    }
    
    private func setupLayer() {
//        player = AVPlayer(url: URL(string: audioUrl)!)
//        player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: nil) {[weak self] time in
//            guard let self = self else {return}
//            let totalTime = CMTimeGetSeconds(self.player.currentItem!.duration)
//            let currentTime = time.value/Int64(time.timescale)
//            let progress: Double = totalTime/Double(currentTime)
//            print("progress: \(progress)")
//        }
        
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer?.frame = CGRect(x: 0, y: 70, width: kMainScreenWidth, height: 100)
    }
    
    @objc private func clickAction() {
//        isPlaying.toggle()
//
//        if isPlaying {
//            player?.pause()
//        }else {
//            player?.play()
//        }
    }
    
    @objc private func willResignActive() {
        var param: [String: Any] = [:]
        //设置播放速率
        param[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        //当前播放时间 在计时器中修改
        param[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0.0
        
        DispatchQueue.main.async {
            //歌曲名称
            param[MPMediaItemPropertyTitle] = "【人格塑造】你的弱点决定你走什么路，能走多远"
            //演唱者
            param[MPMediaItemPropertyArtist] = "杨琳"
            //专辑缩略图
            param[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: self.radioImageView.image?.size ?? CGSize.zero, requestHandler: { size in
                var image: UIImage?
                DispatchQueue.main.async {
                    image = self.radioImageView.image
                }
                return image ?? UIImage()
            })
            
            //音乐剩余时长
            param[MPMediaItemPropertyPlaybackDuration] = "2228"
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo = param
        }
    }
    
    @objc private func timerChange() {
//        var param = MPNowPlayingInfoCenter.default().nowPlayingInfo
//        let time = player?.currentItem?.duration ?? CMTime(value: 0, timescale: 0)
//        ZFPrint("seconds: \(time.seconds)")
//        param?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time.seconds
    }
    
    private func getTotalDuration(url: String, isFilePath: Bool = false) -> Int {
        var totalSeconds = 0
        if isFilePath {
            let audioUrl = URL(fileURLWithPath: url)
            totalSeconds = getAvAssetSeconds(audioUrl: audioUrl)
        }else {
            if let audioUrl = URL(string: url) {
                totalSeconds = getAvAssetSeconds(audioUrl: audioUrl)
            }
        }
        return totalSeconds
    }
    
    private func getAvAssetSeconds(audioUrl: URL) -> Int {
        let audioAsset = AVURLAsset(url: audioUrl, options: [AVURLAssetPreferPreciseDurationAndTimingKey: false])
        let duration = audioAsset.duration
        let seconds = Int(duration.value)/Int(duration.timescale)
//        let seconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(value: 0, timescale: 0))
        
        return seconds
    }
    
    private func getTimeStringWith(totalSeconds: Int) -> String {
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    @objc private func showAlertView() {
//        myQueue.async {
//            let semaphore = DispatchSemaphore(value: 0)
//            DispatchQueue.main.async {
//                self.setupAlertView(title: "这是第一个弹框") {
//                    semaphore.signal()
//                }
//            }
//
//            semaphore.wait()
//            DispatchQueue.main.async {
//                self.setupAlertView(title: "这是第二个弹框") {
//                    semaphore.signal()
//                }
//            }
//
//            semaphore.wait()
//            DispatchQueue.main.async {
//                self.setupAlertView(title: "这是第三个弹框") {
//                    semaphore.signal()
//                }
//            }
//        }
    }
    
    private func setupAlertView(title: String, block: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定", style: .default) { _ in
            block()
        }
        alertVC.addAction(sureAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - speech
//    @objc private func recordButtonTapped() throws {
//        if audioEngine.isRunning {
//            audioEngine.stop()
//            recognitionRequest?.endAudio()
//            recordButton.isEnabled = false
//            recordButton.setTitle("Stopping", for: .disabled)
//        } else {
//            do {
//                try startRecording()
//                recordButton.setTitle("Stop Recording", for: [])
//            } catch {
//                recordButton.setTitle("Recording Not Available", for: [])
//            }
//        }
//    }
//
//    private func startRecording() throws {
//        recognitionTask?.cancel()
//        self.recognitionTask = nil
//
//        // Configure the audio session for the app.
//        let audioSession = AVAudioSession.sharedInstance()
//        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
//        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//        let inputNode = audioEngine.inputNode
//
//        // Create and configure the speech recognition request.
//        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
//        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
//        recognitionRequest.shouldReportPartialResults = true
//
//        // Keep speech recognition data on device
//        if #available(iOS 13, *) {
//            recognitionRequest.requiresOnDeviceRecognition = false
//        }
//
//        // Create a recognition task for the speech recognition session.
//        // Keep a reference to the task so that it can be canceled.
//        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
//            var isFinal = false
//
//            if let result = result {
//                isFinal = result.isFinal
//                let text = result.bestTranscription.formattedString
//                print("Text \(text)")
//                self.resultLabel.text = text
//            }
//
//            if error != nil || isFinal {
//                // Stop recognizing speech if there is a problem.
//                self.audioEngine.stop()
//                inputNode.removeTap(onBus: 0)
//
//                self.recognitionRequest = nil
//                self.recognitionTask = nil
//
//                self.recordButton.isEnabled = true
//                self.recordButton.setTitle("Start Recording", for: [])
//            }
//        }
//
//        // Configure the microphone input.
//        let recordingFormat = inputNode.outputFormat(forBus: 0)
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
//            self.recognitionRequest?.append(buffer)
//        }
//
//        audioEngine.prepare()
//        try audioEngine.start()
//    }
    
    //MARK: - notify
    @objc private func handleNotification(_ notify: Notification) {
        if notify.name == .event_remoteControlPlay {
            player?.play()
        }else if notify.name == .event_remoteControlPause {
            player?.pause()
        }
    }
}

extension SubViewController: SFSpeechRecognizerDelegate {
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("Start Recording", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition Not Available", for: .disabled)
        }
    }
}

struct TapDetailModel: Decodable {
    var tap: DetailTapInfo
    var needBuy: Bool = true
    var isPraied: Bool = false
    var isFocused: Bool = false
}

struct DetailTapInfo: Decodable {
    var expertId: Int
    var totalTime: Int
    var tapId: Int
    var picture: String
    var tapUrl: String
    var name: String
    var courseId: Int
    var status: Int
    var price: Float
}


