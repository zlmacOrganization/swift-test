//
//  StoreKitManager.swift
//  SwiftTest
//
//  Created by zhangliang on 2021/9/22.
//  Copyright © 2021 zhangliang. All rights reserved.
//

import UIKit
import StoreKit

final class StoreKitManager: NSObject {
    static let shareInstance = StoreKitManager()
    
    private override init() {
        
    }
    
    func stratPayRequest(_ identifier: String) {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: Set([identifier]))
            request.delegate = self
            request.start()
        }else {
            
        }
    }
}

extension StoreKitManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        if products.isEmpty {
            //查找不到商品信息
        }else {
            //支付中
            for product in products {
                if product.productIdentifier == "myIdentifier" {
                    let payment = SKPayment(product: product)
                    SKPaymentQueue.default().add(payment)
                    break
                }
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        
    }
    
    func requestDidFinish(_ request: SKRequest) {
        
    }
}

extension StoreKitManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        if !transactions.isEmpty {
            let action = transactions[0]
            switch action.transactionState {
            case .purchasing:
                ZFPrint("正在交易")
            case .purchased:
                ZFPrint("交易成功")
                completeTransaction(action)
                queue.finishTransaction(action)
            case .failed:
                ZFPrint("交易失败")
                failedTransaction(action)
                queue.finishTransaction(action)
            case .restored:
                ZFPrint("购买过该商品")
                queue.finishTransaction(action)
            case .deferred:
                ZFPrint("未决定")
            default:
                break
            }
        }
    }
    
    private func completeTransaction(_ transactions: SKPaymentTransaction) {
        //正在验证
        let identifier = transactions.payment.productIdentifier
        if let receiptUrl = Bundle.main.appStoreReceiptURL {
            if let data = try? Data(contentsOf: receiptUrl) {
                let receiptString = data.base64EncodedString(options: .endLineWithLineFeed)
                if identifier.isEmpty {
                    failedTransaction(transactions)
                }else {
                    //向自己的服务器验证购买凭证
                    confirmRequest(receipt: receiptString)
                }
            }
        }
    }
    
    private func confirmRequest(receipt: String) {
        
    }
    
    private func failedTransaction(_ transactions: SKPaymentTransaction) {
        if let error = transactions.error as? SKError, error.code == SKError.paymentCancelled {
            //cancel
        }else {
            //failed
        }
    }
}
