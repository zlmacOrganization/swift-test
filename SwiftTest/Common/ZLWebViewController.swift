//
//  ZLWebViewController.swift
//  SupvpSwift
//
//  Created by ZhangLiang on 2019/6/11.
//  Copyright © 2019 ZhangLiang. All rights reserved.
//

import UIKit
import WebKit
import Photos
import System
import AppleArchive
import QuickLook

class ZLWebViewController: BaseViewController {
    
    var zlUrlString: String?
    var titleName: String?
    
    private let bottomBarHeight: CGFloat = 40
    private let loadingWidth: CGFloat = 60
    private var isActivityHidden = false
    private var activityView: UIActivityIndicatorView!
    
    private var webView: WKWebView!
    
    private var pdfView: PDFView?
    private var previewVC: QLPreviewController = QLPreviewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = titleName {
            self.title = name
        }

        previewVC.dataSource = self
        
        leftImageName = "btn_close_normal"
        configureWebView()
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightItemClick))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.configuration.userContentController.add(self, name: "zlTest")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "zlTest")
    }
    
    private func configureWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        
        webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.backgroundColor = .white
        view.addSubview(webView)
        
        if let urlString = zlUrlString {
            let request = URLRequest(url: URL(string: urlString)!)
            webView.load(request)
        }
        
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets.zero)
        }
        
        activityView = UIActivityIndicatorView(frame: CGRect(x: (kMainScreenWidth - loadingWidth)/2, y: (view.frame.size.height - loadingWidth)/2 - loadingWidth, width: loadingWidth, height: loadingWidth))
        activityView.style = .medium
        view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    override func baseBackButtonClick() {
        if webView.canGoBack {
            webView.goBack()
        }else{
            back()
        }
    }
    
    private func configureToolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: kMainScreenHeight - bottomBarHeight - iphoneXBottomMargin, width: kMainScreenWidth, height: bottomBarHeight))
        toolBar.tintColor = UIColor.darkGray
        
        let gobackButton = UIBarButtonItem(image: UIImage(named: "browser_back"), style: .plain, target: target, action: #selector(backAction))
//        let shareButton = CommonFunction.creatBarButtonItem(imageName: "browser_share", target: self, action: #selector(shareAction))
        let refreshButton = UIBarButtonItem(image: UIImage(named: "browser_refresh"), style: .plain, target: target, action: #selector(refreshAction))
        let closeButton = UIBarButtonItem(image: UIImage(named: "browser_close"), style: .plain, target: target, action: #selector(closeAction))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.items = [gobackButton, flexSpace, refreshButton, flexSpace, flexSpace, flexSpace, closeButton]
        view.addSubview(toolBar)
    }
    
    //MARK: - action
    @objc private func backAction() {
        baseBackButtonClick()
    }
    
    @objc private func shareAction() {
        
    }
    
    @objc private func refreshAction() {
        webView.reload()
    }
    
    @objc private func closeAction() {
        activityView?.stopAnimating()
        baseBackButtonClick()
    }
    
    //MARK: - webView new api
    @objc private func takeSnapshot() {
        if #available(iOS 11.0, *) {
            let config = WKSnapshotConfiguration()
            config.rect = CGRect(x: 0, y: 0, width: kMainScreenWidth, height: 200)
            
            // https://www.hangge.com/blog/cache/detail_1102.html
            webView.takeSnapshot(with: config) { [weak self] image, error in
                guard let self = self else {return}
                
                if let image = image {
//                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
                    
                    PHPhotoLibrary.shared().performChanges {
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    } completionHandler: { success, error in
                        DispatchQueue.main.async {
                            if success {
                                self.noticeOnlyText("已保存到相册")
                            }else {
                                self.noticeOnlyText("保存失败")
                            }
                        }
                    }

                }
            }
        }
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if let _ = error {
            self.noticeOnlyText("保存失败")
        }else {
            self.noticeOnlyText("已保存到相册")
        }
    }
    
    @objc private func savePdf() {
//        let downloadDir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
        let savePath = getFilePathUrl()
                
        if #available(iOS 14.0, *) {
            let pdfConfiguration = WKPDFConfiguration()
            pdfConfiguration.rect = CGRect(x: 0, y: 0, width: 595.28, height: 841.89)
            
            let html = """
            <html>
            <body>
            <h1>Some Title</h1>
            <p>
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Tellus integer feugiat scelerisque varius. Nunc faucibus a pellentesque sit. Sagittis vitae et leo duis. Posuere lorem ipsum dolor sit amet consectetur. Porta non pulvinar neque laoreet suspendisse interdum. Dui faucibus in ornare quam viverra orci. Nulla facilisi etiam dignissim diam quis enim. Elementum pulvinar etiam non quam lacus suspendisse. Donec enim diam vulputate ut pharetra sit amet aliquam. Nunc mattis enim ut tellus elementum sagittis vitae. Vitae semper quis lectus nulla at volutpat diam ut. Enim eu turpis egestas pretium aenean pharetra magna ac.

                Cras sed felis eget velit aliquet sagittis id consectetur purus. Urna nunc id cursus metus aliquam eleifend mi. Interdum varius sit amet mattis vulputate enim nulla aliquet. At risus viverra adipiscing at in tellus integer feugiat. Dolor purus non enim praesent elementum facilisis leo vel fringilla. Interdum velit euismod in pellentesque massa placerat duis ultricies. Amet facilisis magna etiam tempor orci eu. Proin fermentum leo vel orci porta non pulvinar neque. Et magnis dis parturient montes nascetur ridiculus mus mauris vitae. Sagittis orci a scelerisque purus.
            </p>
            </body>
            </html>
            """
            webView.loadHTMLString(html, baseURL: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.webView.createPDF(configuration: pdfConfiguration) { result in
                    switch result {
                    
                    case .success(let data):
                        do {
                            try data.write(to: savePath)
                            print("Successfully created and saved pdf…\(savePath)")
                        } catch let error {
                            print("Could not _save_ pdf: \(error)")
                        }
                    case .failure(let error):
                        print("Could not create pdf: \(error)")
                    }
                }
            }
        }
    }
    
    private func previewFile() {
        present(previewVC, animated: true)
        
//        let previewWebVC = ZLWebViewController()
//        previewWebVC.zlUrlString = getFilePathUrl().absoluteString
//        present(previewWebVC, animated: true)
        
//        if pdfView == nil {
//            pdfView = PDFView(frame: view.bounds)
//            pdfView?.autoScales = true
//            pdfView?.document = PDFDocument(url: getFilePathUrl())
//            view.addSubview(pdfView!)
//        }
    }
    
    private func documentPicker() {
//        let documentVC = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf", "public.text", "com.microsoft.word.doc", "org.openxmlformats.wordprocessingml.document", "org.openxmlformats.spreadsheetml.sheet", "com.microsoft.excel.xls", "com.microsoft.powerpoint.​ppt"], in: .open)
        
        let documentVC = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .text, .directory])
        documentVC.modalPresentationStyle = .fullScreen
        documentVC.delegate = self
        present(documentVC, animated: true)
    }
    
    @objc private func rightItemClick() {
        let alertController = UIAlertController(title: "select a menu", message: nil, preferredStyle: .actionSheet)
        
        var previewAction: UIAlertAction?
        var documentAction: UIAlertAction?
        let filePath = CommonFunction.creatDocumentSaveFile(subfile: "pdfTest") ?? ""
        if FileManager.default.fileExists(atPath: "\(filePath)/swiftPdf.pdf") {
            previewAction = UIAlertAction(title: "preview PDF", style: .default) {[weak self] _ in
                guard let self = self else { return }
                self.previewFile()
            }
            
            documentAction = UIAlertAction(title: "show document", style: .default) {[weak self] _ in
                guard let self = self else { return }
                self.documentPicker()
            }
        }
        
        let outlineAction = UIAlertAction(title: "savePdf", style: .default) { _ in
            self.savePdf()
        }
        
        let thumbAction = UIAlertAction(title: "snapshot", style: .default) { _ in
            self.takeSnapshot()
        }
        
        let searchAction = UIAlertAction(title: "findConfiguration", style: .default) { _ in
            self.findConfig()
        }
        
        let compressAction = UIAlertAction(title: "compress", style: .default) { _ in
            self.compressAction()
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        if let previewAction = previewAction {
            alertController.addAction(previewAction)
        }
        
        if let documentAction = documentAction {
            alertController.addAction(documentAction)
        }
        
        alertController.addAction(outlineAction)
        alertController.addAction(thumbAction)
        alertController.addAction(searchAction)
        alertController.addAction(compressAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func findConfig() {
        if #available(iOS 14.0, *) {
            webView.find("教练", configuration: WKFindConfiguration()) { result in
                print("result: \(result.matchFound)")
            }
        }
    }
    
    private func compressAction() {
//        if #available(iOS 14.0, *) {
//            if let file = CommonFunction.creatDocumentSaveFile(subfile: "pdfTest") {
//                let sourceFilePath = FilePath(file + "swiftPdf.pdf")
//                guard let readFileStream = ArchiveByteStream.fileStream(
//                        path: sourceFilePath,
//                        mode: .readOnly,
//                        options: [ ],
//                        permissions: FilePermissions(rawValue: 0o644)) else {
//                    return
//                }
//                
//                do {
//                    try? readFileStream.close()
//                }
//            }
//        }
    }
    
    func getFilePathUrl() -> URL {
        let downloadDir = CommonFunction.creatDocumentSaveFile(subfile: "pdfTest") ?? ""
        let savePath = URL(fileURLWithPath: downloadDir).appendingPathComponent("swiftPdf").appendingPathExtension("pdf")
        return savePath
    }
}

extension ZLWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView didFinish ++++")
        isActivityHidden = true
        activityView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView didFail ++++")
        isActivityHidden = true
        activityView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit navigation")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            if !self.isActivityHidden {
//                self.activityView.stopAnimating()
//                self.isActivityHidden = true
//            }
//        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var policy: WKNavigationActionPolicy = .allow
        let host = navigationAction.request.url?.host
        
        if host == "itunes.apple.com" || host == "apps.apple.com" {
            policy = .cancel
        }
        
        decisionHandler(policy)
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        decisionHandler(.allow)
//    }
}

@available(iOS 13.0, *)
extension ZLWebViewController {
    
}

extension ZLWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "zlTest" {
//            debugPrint("zlTest ++++")
            webView.evaluateJavaScript("gettime()") { (obj, error) in
                debugPrint("obj: \(String(describing: obj)), error: \(String(describing: error))")
            }
        }
    }
}

extension ZLWebViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let savePath = getFilePathUrl()
        return savePath as QLPreviewItem
    }
}

extension ZLWebViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let isAuth = urls.first?.startAccessingSecurityScopedResource() ?? false
        if let url = urls.first, isAuth {
            var error: NSError?
            let fileCoord = NSFileCoordinator()
            
            fileCoord.coordinate(readingItemAt: url, error: &error) { resultUrl in
                let fileName = resultUrl.lastPathComponent
                print("coordinate path: \(fileName)")
            }
            urls.first?.stopAccessingSecurityScopedResource()
        }
    }
}
