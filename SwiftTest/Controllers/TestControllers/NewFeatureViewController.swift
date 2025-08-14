//
//  NewFeatureViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/6/24.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit
import AVFAudio
import ReplayKit
import SoundAnalysis
import NetworkExtension

@available(iOS 14.0, *)
class NewFeatureViewController: UIViewController {
    private var isShowTableView: Bool = true
    private var tableView: UITableView!
    private var collectionView: UICollectionView!
    
    private var items = Array(0...20).map { String($0) }
    
    struct Model {
        var identifier = UUID()
        // Add additional properties for your own model here.
    }

    private let models = (1...200).map { _ in
        return Model()
    }

    /// An `AsyncFetcher` that is used to asynchronously fetch `DisplayData` objects.
    private let asyncFetcher = AsyncFetcher()
    
//    @available(iOS 14.0, *)
    private lazy var dataSource = makeDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let rightButton = CommonFunction.createButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44), title: "change", textColor: UIColor.purple, font: UIFont.systemFont(ofSize: 15), imageName: nil, isBackgroundImage: false, target: self, action: #selector(rightButtonItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        configureTableView()
        configureCollectionView()
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.zl_registerCell(UITableViewCell.self)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (kMainScreenWidth - 30)/2, height: 100)
        collectionView = UICollectionView(frame: CGRect(x: kMainScreenWidth, y: 0, width: kMainScreenWidth, height: kMainScreenHeight), collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.zl_registerCell(PrefetchCollectionCell.self)
        view.addSubview(collectionView)
    }
    
    private func collectionConfiguration() {
//        if #available(iOS 14.0, *) {
            var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            config.trailingSwipeActionsConfigurationProvider = {indexPath in
                let action = UIContextualAction(style: .normal, title: "haha", handler: { contextAction, view, completion in
                    ZFPrint("la la la la")
                    completion(true)
                })
                action.image = UIImage(systemName: "checkmark")
                action.backgroundColor = .systemGreen
                return UISwipeActionsConfiguration(actions: [action])
            }
            
            let layout = UICollectionViewCompositionalLayout.list(using: config)
            collectionView = UICollectionView(frame: CGRect(x: kMainScreenWidth, y: 0, width: kMainScreenWidth, height: kMainScreenHeight), collectionViewLayout: layout)
            collectionView.dataSource = dataSource
            view.addSubview(collectionView)

            var snapshot = NSDiffableDataSourceSnapshot<String, String>()
            snapshot.appendSections(["Section 1"])
            snapshot.appendItems(items)
            dataSource.apply(snapshot)
//        }
    }
    
    @available(iOS 14.0, *)
    func makeDataSource() -> UICollectionViewDiffableDataSource<String, String> {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, name in

            var content = cell.defaultContentConfiguration()
            content.text = name
            cell.contentConfiguration = content
        }

        return UICollectionViewDiffableDataSource<String, String>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        )
    }
    
    @objc private func rightButtonItemClick() {
        isShowTableView.toggle()
        
        tableView.isHidden = !isShowTableView
        
        if isShowTableView {
            UIView.animate(withDuration: 0.2) {
                self.collectionView.frame = CGRect(x: kMainScreenWidth, y: 0, width: kMainScreenWidth, height: kMainScreenHeight)
            }
        }else {
            UIView.animate(withDuration: 0.2) {
                self.collectionView.frame = CGRect(x: 0, y: 0, width: kMainScreenWidth, height: kMainScreenHeight)
            }
        }
//        collectionView.isHidden = isShowTableView
    }

    @objc private func buttonClick() {
        back()
    }
}

//MARK: - tableView
@available(iOS 14.0, *)
extension NewFeatureViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = "item \(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if Bool.random() {
            if indexPath.row == 0 || indexPath.row == 1 {
                broadcastActivity()
            }else {
                startRecordAction()
            }
            
//        }else {
//            if #available(iOS 15.0, *) {
//                guard let selectedHero = dataSource.itemIdentifier(for: indexPath) else {
//                    tableView.deselectRow(at: indexPath, animated: true)
//                    return
//                }
//                let snapshot = dataSource.snapshot()
//                snapshot.reconfigureItems([selectedHero])
//            }
//        }
    }
}

//MARK: - collectionView
@available(iOS 14.0, *)
extension NewFeatureViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.zl_dequeueReusableCell(PrefetchCollectionCell.self, indexPath: indexPath)
        
        let model = models[indexPath.row]
        let identifier = model.identifier
        cell.representedIdentifier = identifier
        
        // Check if the `asyncFetcher` has already fetched data for the specified identifier.
        if let fetchedData = asyncFetcher.fetchedData(for: identifier) {
            // The data has already been fetched and cached; use it to configure the cell.
            cell.configure(with: fetchedData)
        } else {
            // There is no data available; clear the cell until we've fetched data.
            cell.configure(with: nil)

            // Ask the `asyncFetcher` to fetch data for the specified identifier.
            asyncFetcher.fetchAsync(identifier) { fetchedData in
                DispatchQueue.main.async {
                    /*
                     The `asyncFetcher` has fetched data for the identifier. Before
                     updating the cell, check if it has been recycled by the
                     collection view to represent other data.
                     */
                    guard cell.representedIdentifier == identifier else { return }
                    
                    // Configure the cell with the fetched image.
                    cell.configure(with: fetchedData)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CommonFunction.audioAuthorization {
            let soundVC = SoundAnalyzeController()
            self.navigationController?.pushViewController(soundVC, animated: true)
        } notAllow: {

        } notDetermined: {
            let soundVC = SoundAnalyzeController()
            self.navigationController?.pushViewController(soundVC, animated: true)
        }
        
//        getWifiInfo()
    }
    
    private func getWifiInfo() {
//        let configuration = NEHotspotConfiguration(ssid: "Centa-Offices", passphrase: "Centa@offices", isWEP: true)
//        NEHotspotConfigurationManager.shared.apply(configuration) { error in
//            print("\(String(describing: error)) ++++")
//        }
        
        NEHotspotConfigurationManager.shared.getConfiguredSSIDs { array in
            for str in array {
                print("wifi :\(str)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
//        return true
//    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        ZFPrint("didUpdateFocusIn ++++")
        
        if let preIndexPath = context.previouslyFocusedIndexPath, let cell = collectionView.cellForItem(at: preIndexPath) {
            UIView.animate(withDuration: 0.3) {
                cell.contentView.alpha = 0.3
                cell.contentView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }
        }
        
        if let nextIdnexPath = context.nextFocusedIndexPath, let cell = collectionView.cellForItem(at: nextIdnexPath){
            let cellCenter = CGPoint(x: cell.bounds.origin.x + cell.bounds.size.width / 2, y: cell.bounds.origin.y + cell.bounds.size.height / 2)
            let cellLocation = cell.convert(cellCenter, to: collectionView)
            let centerView = collectionView.frame.midY
            let contentYOffset = cellLocation.y - centerView
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                collectionView.contentOffset.y = contentYOffset
                cell.contentView.alpha = 1.0
                cell.contentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                collectionView.layoutIfNeeded()
            })
        }
    }
    
    @available(iOS 14.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: { () -> UIViewController? in
            return self.getDetailController()
        }) { (menu) -> UIMenu? in
            return BlurViewController.createMenuButton()
        }
    }
    
    @available(iOS 14.0, *)
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        animator.addCompletion {
            let detailVC = self.getDetailController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @available(iOS 14.0, *)
    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        // 返回一个Dismiss时的预览视图
        return makeTargetedPreview(for: configuration)
    }
    
    @available(iOS 14.0, *)
    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        // Get the cell for the index of the model
        guard let cell = collectionView.cellForItem(at: indexPath) as? PrefetchCollectionCell else { return nil }
        // Set parameters to a circular mask and clear background
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(ovalIn: cell.contentView.bounds)

        return UITargetedPreview(view: cell.contentView, parameters: parameters)
    }
    
    private func getDetailController() -> UIViewController {
        let detailVC = CollectionDetailViewController()
        detailVC.imageView.image = UIImage(named: "thumb15")
        return detailVC
    }
}

//MARK: - prefetching
@available(iOS 14.0, *)
extension NewFeatureViewController: UICollectionViewDataSourcePrefetching {
    //https://developer.apple.com/documentation/uikit/uicollectionviewdatasourceprefetching/prefetching_collection_view_data
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let model = models[indexPath.row]
            asyncFetcher.fetchAsync(model.identifier)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let model = models[indexPath.row]
            asyncFetcher.cancelFetch(model.identifier)
        }
    }
}

@available(iOS 14.0, *)
extension NewFeatureViewController: RPPreviewViewControllerDelegate, RPBroadcastActivityViewControllerDelegate {
    private func startRecordAction() {
        if RPScreenRecorder.shared().isRecording {
            RPScreenRecorder.shared().stopRecording { previewController, error in
                if let preVC = previewController {
                    preVC.previewControllerDelegate = self
                    self.zl_present(preVC)
                }
            }
        }else {
            RPScreenRecorder.shared().isMicrophoneEnabled = true
//            RPScreenRecorder.shared().startCapture { buffer, bufferType, error in
//                ZFPrint("bufferType: \(bufferType)")
//            } completionHandler: { error in
//                ZFPrint("error: \(error?.localizedDescription ?? "")")
//            }

            RPScreenRecorder.shared().startRecording { error in
                ZFPrint("error: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    private func broadcastActivity () {
        RPBroadcastActivityViewController.load { controller, error in
            if let controller = controller {
                controller.delegate = self
                self.zl_present(controller)
            }
        }
    }
    
    //MARK: - RPPreviewViewControllerDelegate
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        ZFPrint("previewControllerDidFinish")
        previewController.dismiss(animated: true, completion: nil)
    }
    
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        ZFPrint("didFinishWithActivityTypes")
    }
    
    //MARK: - RPBroadcastActivityViewControllerDelegate
    func broadcastActivityViewController(_ broadcastActivityViewController: RPBroadcastActivityViewController, didFinishWith broadcastController: RPBroadcastController?, error: Error?) {
        DispatchQueue.main.async {
            broadcastActivityViewController.dismiss(animated: true, completion: nil)
        }
    }
}

class DisplayData: NSObject {
    var color: UIColor = UIColor.lightGray
}

class PrefetchCollectionCell: UICollectionViewCell {
    /// The `UUID` for the data this cell is presenting.
    var representedIdentifier: UUID?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: DisplayData?) {
        backgroundColor = data?.color
    }
}


//MARK: - sound analyze
@available(iOS 13.0, *)
class SoundAnalyzeController: UIViewController {
    private let audioEngine: AVAudioEngine = AVAudioEngine()
    private let inputBus: AVAudioNodeBus = AVAudioNodeBus(0)
    private var inputFormat: AVAudioFormat!
    private var streamAnalyzer: SNAudioStreamAnalyzer!
    private let resultsObserver = SoundResultsObserver()
    private let analysisQueue = DispatchQueue(label: "com.example.AnalysisQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputFormat = audioEngine.inputNode.inputFormat(forBus: inputBus)
        do {
            try audioEngine.start()
            audioEngine.inputNode.installTap(onBus: inputBus, bufferSize: 8192, format: inputFormat, block: analyzeAudio(buffer:at:))
            streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
            
            if #available(iOS 15.0, *) {
                let request = try SNClassifySoundRequest(classifierIdentifier: SNClassifierIdentifier.version1)
                try streamAnalyzer.add(request, withObserver: resultsObserver)
                
            }
        } catch  {
            print("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        audioEngine.stop()
    }
    
    private func analyzeAudio(buffer: AVAudioBuffer, at time: AVAudioTime) {
        analysisQueue.async {
            self.streamAnalyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
        }
    }
}

@available(iOS 13.0, *)
class SoundResultsObserver: NSObject, SNResultsObserving {

    func request(_ request: SNRequest, didProduce result: SNResult) { // Mark 1

        guard let result = result as? SNClassificationResult else  { return } // Mark 2

        guard let classification = result.classifications.first else { return } // Mark 3

        let timeInSeconds = result.timeRange.start.seconds // Mark 4

        let formattedTime = String(format: "%.2f", timeInSeconds)
        print("Analysis result for audio at time: \(formattedTime)")

        let confidence = classification.confidence * 100.0
        let percentString = String(format: "%.2f%%", confidence)

        print("\(classification.identifier): \(percentString) confidence.\n") // Mark 5
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The the analysis failed: \(error.localizedDescription)")
    }

    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
}
