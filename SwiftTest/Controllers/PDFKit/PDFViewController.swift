//
//  PDFViewController.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/9/3.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: BaseViewController {
    private var pdfView: PDFView!
    private var document: PDFDocument?
    private var zoomBaseView: UIView!
    private var hasDisplay: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(menuAction))
        navigationItem.rightBarButtonItem = menuItem

        pdfView = PDFView(frame: view.bounds)
        pdfView.autoScales = true
        
        if #available(iOS 16.0, *) {
            pdfView.isFindInteractionEnabled = true
        }
        
        view.addSubview(pdfView)
        
        let document = PDFDocument(url: Bundle.main.url(forResource: "sample", withExtension: "pdf")!)
        document?.delegate = self
        self.document = document
        pdfView.document = document
        
        configureViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismissFindNav()
    }
    
    private func configureViews() {
        let findBtn = CommonFunction.createButton(frame: .zero, title: nil, textColor: nil, font: nil, imageName: "search_icon", target: self, action: #selector(findAction))
        view.addSubview(findBtn)
        
        let zoomInBtn = CommonFunction.createButton(frame: CGRect.zero, title: "+", textColor: UIColor.blue, font: UIFont.systemFont(ofSize: 18), target: self, action: #selector(zoomIn))
        setButtonLayer(zoomInBtn)
        view.addSubview(zoomInBtn)
        
        let zoomOutBtn = CommonFunction.createButton(frame: CGRect.zero, title: "-", textColor: UIColor.blue, font: UIFont.systemFont(ofSize: 18), target: self, action: #selector(zoomOut))
        setButtonLayer(zoomOutBtn)
        view.addSubview(zoomOutBtn)
        
        let width: CGFloat = 50
        zoomInBtn.snp.makeConstraints { make in
            make.right.equalTo(-25)
            make.width.height.equalTo(width)
            make.bottom.equalTo(zoomOutBtn.snp.top)
        }
        
        zoomOutBtn.snp.makeConstraints { make in
            make.right.equalTo(-25)
            make.width.height.equalTo(width)
            make.bottom.equalTo(-(iphoneXBottomMargin + 50))
        }
        
        findBtn.snp.makeConstraints { make in
            make.centerX.equalTo(zoomInBtn)
            make.width.height.equalTo(width)
            make.bottom.equalTo(zoomInBtn.snp.top).offset(-10)
        }
    }
    
    private func setButtonLayer(_ button: UIButton) {
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.blue.cgColor
    }
    
    //MARK: - action
    @objc private func menuAction() {
        let alertController = UIAlertController(title: "select a menu", message: nil, preferredStyle: .actionSheet)
        let outlineAction = UIAlertAction(title: "outline", style: .default) { _ in
            self.showOutline()
        }
        
        let thumbAction = UIAlertAction(title: "thumbnail", style: .default) { _ in
            self.showThumbnail()
        }
        
        let searchAction = UIAlertAction(title: "search", style: .default) { _ in
            self.searchAction()
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertController.addAction(outlineAction)
        alertController.addAction(thumbAction)
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showOutline() {
        if let outline = document?.outlineRoot {
            let outlineVC = OutlineViewController()
            outlineVC.outlineRoot = outline
            outlineVC.selectOutlineBlock = {outline in
                if let action = outline.action as? PDFActionGoTo {
                    self.pdfView.go(to: action.destination)
                }
            }
            
            zl_pushViewController(outlineVC)
//            let nav = BaseNavigationController(rootViewController: outlineVC)
//            zl_present(outlineVC)
            
//            if #available(iOS 15.0, *) {
//                if let sheet = nav.sheetPresentationController {
//                    sheet.detents = [.medium(), .large()]
//                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//                    //prevent dismissal
//                    nav.isModalInPresentation = true
//                    zl_present(nav)
//                }
//            }
        }else {
            let alertController = UIAlertController(title: "Attention", message: "This pdf do not have outline!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func showThumbnail() {
        let thumbVC = ThumbnailViewController()
        thumbVC.delegate = self
        thumbVC.pdfDocument = document
//        zl_pushViewController(thumbVC)
        zl_present(BaseNavigationController(rootViewController: thumbVC))
    }
    
    private func searchAction() {
        let searchVC = PDFSearchViewController()
        searchVC.pdfDocument = document
        searchVC.selectSearchBlock = {selection in
            self.pdfView.currentSelection = selection
            self.pdfView.go(to: selection)
        }
        zl_present(BaseNavigationController(rootViewController: searchVC))
    }
    
    @objc private func findAction() {
        if #available(iOS 16.0, *) {
            self.pdfView.findInteraction.presentFindNavigator(showingReplace: true)
        }
    }
    
    private func dismissFindNav() {
        if #available(iOS 16.0, *) {
            self.pdfView.findInteraction.dismissFindNavigator()
        }
    }
    
    //放大
    @objc private func zoomIn() {
        UIView.animate(withDuration: 0.1) {
            self.pdfView.zoomIn(nil)
        }
    }
    
    //缩小
    @objc private func zoomOut() {
        UIView.animate(withDuration: 0.1) {
            self.pdfView.zoomOut(nil)
        }
    }
}

extension PDFViewController: ThumbnailViewControllerDelegate, PDFDocumentDelegate {
    func didSelect(at item: Int) {
        if let page = document?.page(at: item) {
            pdfView.go(to: page)
            
//            let annotation = PDFAnnotation(bounds: CGRect(x: 10, y: 10, width: 80, height: 80), forType: .square, withProperties: nil)
//            annotation.color = .red
//            let border = PDFBorder()
//            border.lineWidth = 2
//
//            annotation.border = border
//            page.addAnnotation(annotation)
        }
    }
    
    func classForPage() -> AnyClass {
        return WatermarkPage.self
    }
}

@available(iOS 16.0, *)
extension PDFViewController: UIFindInteractionDelegate {
    func findInteraction(_ interaction: UIFindInteraction, sessionFor view: UIView) -> UIFindSession? {
//        return UITextSearchingFindSession(searchableObject: <#T##__UITextSearching#>)
        return nil
    }
}

class WatermarkPage: PDFPage {
    override func draw(with box: PDFDisplayBox, to context: CGContext) {
        super.draw(with: box, to: context)

        UIGraphicsPushContext(context)
        context.saveGState()

        let pageBoundns = self.bounds(for: box)
        context.translateBy(x: 0.0, y: pageBoundns.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.rotate(by: CGFloat.pi / 4.0)

        let string: NSString = "U s e r   3 1 4 1 5 9"
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5),
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 64)
        ]

        string.draw(at: CGPoint(x: 250, y: 40), withAttributes: attributes)
        context.restoreGState()
        UIGraphicsPopContext()
    }
}
