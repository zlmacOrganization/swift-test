//
//  ImageEditViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/4/1.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit
import VisionKit
import LinkPresentation

enum UnailableConfigType {
    case empty, loading
}

@available(iOS 17.0, *)
class FeatureTestViewController: UIViewController {
    var configType: UnailableConfigType
    
    // MARK: - Properties
    lazy var unavailableView: UIContentUnavailableView = {
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "暂无数据"
        config.textProperties.color = .red
//        config.secondaryText = "正在加载数据..."
        config.image = UIImage(systemName: "exclamationmark.triangle")
        config.imageProperties.tintColor = .red
        
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "重新加载"
        config.button = buttonConfig
        config.buttonProperties.primaryAction = UIAction(title: "", handler: {[weak self] _ in
            self?.reloadData()
        })
        
        let unavailableView = UIContentUnavailableView(configuration: config)
        unavailableView.frame = view.bounds
        unavailableView.isHidden = true
        return unavailableView
    }()
    
    //
    lazy var emptyConfig: UIContentUnavailableConfiguration = {
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "暂无数据"
        config.image = UIImage(systemName: "exclamationmark.triangle")
        return config
    }()
    
    private lazy var interaction: ImageAnalysisInteraction = {
        let interaction = ImageAnalysisInteraction()
        interaction.preferredInteractionTypes = .automatic
        return interaction
    }()

    private let imageAnalyzer = ImageAnalyzer()
    private var imageView: UIImageView!
    
    private var editMenuInteraction: UIEditMenuInteraction!
    
    var tableView: UITableView!
    var contents: [String] = []
    
    init(configType: UnailableConfigType) {
        self.configType = configType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        if configType == .empty {
            view.addSubview(unavailableView)
            setupViewHidden()
        }else if configType == .loading {
            contentUnavailableConfiguration = emptyConfig
        }
        
        navigationItem.rightBarButtonItem = CommonFunction.createBarButtonItem(title: "Edit", target: self, action: #selector(rightButtonClick))
    }
    
    // MARK: - Private Methods
    private func configureViews() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 55
        tableView.backgroundColor = .white
        tableView.zl_registerCell(UITableViewCell.self)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: 200))
        imageView.image = UIImage(named: "test")
        tableView.tableHeaderView = imageView
        imageView.addInteraction(interaction)
        
        editMenuInteraction = UIEditMenuInteraction(delegate: self)
        imageView.addInteraction(editMenuInteraction)
        
        CommonFunction.addTapGesture(with: imageView, target: self, action: #selector(imageClickAction(_:)))
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
            longPress.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
        imageView.addGestureRecognizer(longPress)
    }
    
    private func reloadData() {
        contents = ["JAY ZHOU", "范特西", "八度空间", "叶惠美", "七里香", "十一月的肖邦", "依然范特西", "我很忙", "摩杰座", "跨时代", "惊叹号", "十二新作", "哎呦，不错哦", "周杰伦的床边故事", "最伟大的作品"]
        
        if configType == .empty {
            pleaseWait()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.clearAllNotice()
            self.tableView.reloadData()
            
            if self.configType == .empty {
                self.setupViewHidden()
            }
        })
    }
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        // 切换
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let loadingConfig = UIContentUnavailableConfiguration.loading()
            self.contentUnavailableConfiguration = loadingConfig
        }
        
        // 移除
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.contentUnavailableConfiguration = nil
            self.reloadData()
        }
    }
    
    private func setupViewHidden() {
        unavailableView.isHidden = !contents.isEmpty
    }
    
    @objc func imageClickAction(_ recognizer: UIGestureRecognizer) {
        showLiveText()
    }
    
    @objc func didLongPress(_ recognizer: UIGestureRecognizer) {
        let location = recognizer.location(in: self.view)
        let configuration = UIEditMenuConfiguration(identifier: nil, sourcePoint: location)

        if let interaction = editMenuInteraction {
            interaction.presentEditMenu(with: configuration)
        }
    }
    
    private func showLiveText()  {
        guard let image = imageView.image else { return }
        
        Task {
            let config = ImageAnalyzer.Configuration([.text])
            
            do {
                let analysis = try await imageAnalyzer.analyze(image, configuration: config)
                DispatchQueue.main.async {
                    self.interaction.analysis = nil
                    self.interaction.preferredInteractionTypes = []
                    
                    self.interaction.analysis = analysis
                    self.interaction.preferredInteractionTypes = .automatic
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func rightButtonClick() {
        let provider = LPMetadataProvider()
        
        if let url = URL(string: "https://www.apple.com/ipad") {
            provider.startFetchingMetadata(for: url) { data, error in
                if let data = data {
                    DispatchQueue.main.async {
                        let linkView = LPLinkView(metadata: data)
                        linkView.frame = CGRect(x: (kMainScreenWidth - 150)/2, y: 200, width: 150, height: 150)
                        self.view.addSubview(linkView)
                    }
                }
            }
        }
    }
}

@available(iOS 17.0, *)
extension FeatureTestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        
        cell.textLabel?.text = contents[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row.isMultiple(of: 2) {
            customSheet()
        }else {
            popverVC()
        }
    }
    
    func customSheet() {
        let modalVC = UIViewController()
        modalVC.view.backgroundColor = .lightGray
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [
                    .custom { _ in
                        return 200
                    },
                    .custom { context in
                        return context.maximumDetentValue * 0.6
                    }
                ]
        }
        
        present(modalVC, animated: true)
    }
    
    func popverVC() {
        let modalVC = UIViewController()
        modalVC.view.backgroundColor = .purple
        modalVC.modalPresentationStyle = .popover
        modalVC.preferredContentSize = CGSize(width: 200, height: 200)
        
        if let pop = modalVC.popoverPresentationController {
            let sheet = pop.adaptiveSheetPresentationController
            sheet.sourceView = imageView
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(modalVC, animated: true)
    }
}

@available(iOS 17.0, *)
extension FeatureTestViewController: UILargeContentViewerInteractionDelegate, UIEditMenuInteractionDelegate {
    func largeContentViewerInteraction(
            _ interaction: UILargeContentViewerInteraction,
            didEndOn item: UILargeContentViewerItem?,
            at point: CGPoint
        ) {
            guard let index = tableView.indexPathForRow(at: point) else {
                return
            }

            tableView(tableView, didSelectRowAt: index)
        }
    
    func editMenuInteraction(_ interaction: UIEditMenuInteraction, menuFor configuration: UIEditMenuConfiguration, suggestedActions: [UIMenuElement]) -> UIMenu? {
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { (action) in
            print("Share ++")
        }
        
        let file = UIAction(title: "open file", image: UIImage(systemName: "folder")) { (action) in
            print("open file ++")
        }
        
        let detect = UIAction(title: "detect", image: UIImage(systemName: "ellipsis.circle")) { (action) in
            print("detect ++")
        }
        
        return UIMenu(title: "EditMenu", children: [share, file, detect])
    }
}
