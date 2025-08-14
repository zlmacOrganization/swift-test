//
//  CommonNetRequest.swift
//  SwiftTest
//
//  Created by ZhangLiang on 17/1/9.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit
import Alamofire

final class CommonNetRequest: NSObject {
    
    //MARK: - new
    //返回值为data
    class func new_get(urlString: String, method: HTTPMethod = .get, parammeters: Parameters?, responseBlock: @escaping (_ response: Dictionary<String, Any>?, _ error: Error?) -> ()) {
        AF.request(urlString, method: method, parameters: parammeters).response { response in
            switch response.result {
            case .success(let data):
                do {
                    if let data = data {
                        let jsonDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                        responseBlock(jsonDict, nil)
                    }else {
                        responseBlock(nil, response.error)
                    }

                } catch {
                    responseBlock(nil, response.error)
                }
            case .failure(let error):
                responseBlock(nil, error)
            }
        }
    }
    
    //返回值为Any
    class func new_getJson(urlString: String, method: HTTPMethod = .get, parammeters: Parameters?, responseBlock: @escaping (_ response: Any?, _ error: Error?) -> ()) {
        AF.request(urlString, method: method, parameters: parammeters).responseString { response in
            switch response.result {
            case .success(let str):
                do {
                    if let data = str.data(using: .utf8) {
                        let jsonDict = try JSONSerialization.jsonObject(with: data)
                        responseBlock(jsonDict, nil)
                    }else {
                        responseBlock(nil, response.error)
                    }

                } catch {
                    responseBlock(nil, response.error)
                }
            case .failure(let error):
                responseBlock(nil, error)
            }
        }
    }
    
    class func new_getModel<T: Decodable>(urlString: String, method: HTTPMethod = .get, parammeters: Parameters?, model: T.Type, responseBlock: @escaping (_ response: T?, _ error: Error?) -> ()) {
        
        AF.request(urlString, method: method, parameters: parammeters).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let model):
                responseBlock(model, nil)
            case .failure(let error):
                responseBlock(nil, error)
            }
        }
    }
    
    class func download(_ urlString: String, fileURL: URL? = nil, method: HTTPMethod = .get, parammeters: Parameters? = nil, responseBlock: @escaping (_ response: String?, _ error: Error?) -> ()) {
        let destination: DownloadRequest.Destination = { _, _ in
            
            if let fileURL = fileURL {
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }else {
                let fileDocument = CommonFunction.creatDocumentSaveFile(subfile: "fileDownload") ?? ""
                var documentsUrl = URL(fileURLWithPath: fileDocument)
                if fileDocument.isEmpty {
                    documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                }
                
                let fileName = CommonFunction.getFileName(from: urlString)
                let pathExtension = (urlString as NSString).pathExtension
                let fileURL = documentsUrl.appendingPathComponent("\(fileName).\(pathExtension)")

                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
        }
        
        AF.download(urlString, method: method, parameters: parammeters, to: destination).response { response in
            switch response.result {
            case .success(let url):
                print("filePath: \(url?.path ?? "")")
                responseBlock(url?.path, nil)
            case .failure(let error):
                responseBlock(nil, error)
            }
        }
    }
    
    //MARK: - old func
    class func getResultCode(_ resultDict: Dictionary<String, Any>) -> Int {
        var code = 0
        if ((resultDict["s"] as? NSNumber) != nil) {
            code = Int("\(resultDict["s"] ?? "0")") ?? 0
        }else if ((resultDict["s"] as? String) != nil) {
            code = Int("\(resultDict["s"] ?? "0")") ?? 0
        }
        
        return code
    }
    
    class func get(urlString: String, parammeters: Parameters, success: @escaping (_ codeOK: Bool, _ code: String, _ response: Dictionary<String, Any>) -> (), failure: @escaping (_ error: Error) -> ()) {
        AF.request(urlString, method: .get, parameters: parammeters).response { response in
            switch response.result {
            case .success(let data):
                do {
                    if let data = data, let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        let codeString = dict["error"] as? String ?? "0"
                        let code = CommonNetRequest.getResultCode(dict)
                        success(code == 200, codeString, dict)
                    }else {
                        success(false, "0", [:])
                    }

                } catch {
                    success(false, "0", [:])
                }
                
            case .failure(let error):
                print("request error: \(error)")
                failure(error)
            }
        }
    }
    
    class func post(urlString: String, parammeters: Parameters, success: @escaping (_ codeOK: Bool, _ retcode: Int, _ response: Dictionary<String, Any>) -> (), failure: @escaping (_ error: Error) -> ()) {
        AF.request(urlString, method: .post, parameters: parammeters).response { response in
            switch response.result {
            case .success(let data):
                do {
                    if let data = data, let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                        let codeString = dict["error"] as? String ?? "0"
                        let code = CommonNetRequest.getResultCode(dict)
                        success(code == 200, code, dict)
                    }else {
                        success(false, 0, [:])
                    }

                } catch {
                    success(false, 0, [:])
                }
                
            case .failure(let error):
                print("request error: \(error)")
                failure(error)
            }
        }
    }
    
}
