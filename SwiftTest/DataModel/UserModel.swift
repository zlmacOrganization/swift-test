//
//  UserModel.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2018/1/20.
//  Copyright © 2018年 ZhangLiang. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    var userId: Int64 = 0
    var userName: String = ""
    var age: Int64 = 0
    
    @objc var name: String? {
            didSet {
                print("didSetCalled")
            }
        }
    
    //https://stackoverflow.com/questions/40533914/is-there-any-alternative-for-nsinvocation-in-swift
    func invocationTest() {
        let nsInvocationClass: AnyClass = NSClassFromString("NSInvocation")!
        let sel = #selector(setter:name)
        
        let nsInvocationInitializer = unsafeBitCast(
                    method_getImplementation(
                        class_getClassMethod(nsInvocationClass, NSSelectorFromString("invocationWithMethodSignature:"))!
                    ),
                    to: (@convention(c) (AnyClass?, Selector, Any?) -> Any).self
            )
        
        let nsInvocationSetSelector = unsafeBitCast(
                    class_getMethodImplementation(nsInvocationClass, NSSelectorFromString("setSelector:")),
                    to:(@convention(c) (Any, Selector, Selector) -> Void).self
            )
        
        let nsInvocationSetArgAtIndex = unsafeBitCast(
                    class_getMethodImplementation(nsInvocationClass, NSSelectorFromString("setArgument:atIndex:")),
                    to:(@convention(c)(Any, Selector, OpaquePointer, NSInteger) -> Void).self
            )
        
        let methodSignatureForSelector = NSSelectorFromString("methodSignatureForSelector:")
                let getMethodSigniatureForSelector = unsafeBitCast(
                    method(for: methodSignatureForSelector)!,
                    to: (@convention(c) (Any?, Selector, Selector) -> Any).self
            )
        
        let namyPropertyMethodSigniature = getMethodSigniatureForSelector(self, methodSignatureForSelector, sel)

        let invocation = nsInvocationInitializer(
            nsInvocationClass,
            NSSelectorFromString("invocationWithMethodSignature:"),
            namyPropertyMethodSigniature
        ) as! NSObject // Really it's an NSInvocation, but that can't be expressed in Swift.
        
        nsInvocationSetSelector(
            invocation,
            NSSelectorFromString("setSelector:"),
            sel
        )
        
        var localName = "New name" as NSString
        
        withUnsafePointer(to: &localName) { stringPointer in
            nsInvocationSetArgAtIndex(
                invocation,
                NSSelectorFromString("setArgument:atIndex:"),
                OpaquePointer(stringPointer),
                2
            )
        }
        
        invocation.perform(NSSelectorFromString("invokeWithTarget:"), with: self)
    }
}

class UserInfo: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    var id: String
    var name: String
    
    static let saveKey = "user_keychain"
    
    init(_ id: String, _ name : String) {
        self.id = id
        self.name = name
    }
    
    required convenience init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: "id") as? String,
              let name = coder.decodeObject(forKey: "name") as? String
        else { return nil }
        
        self.init(id, name)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: "id")
        coder.encode(self.name, forKey: "name")
    }
    
    //MARK: - archive
    // iOS12 and later
    func saveData() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
            UserKeychain.save(key: UserInfo.saveKey, data: data)
        } catch  {
            ZFPrint("archive save failed")
        }
    }
    
    func deleteData() {
        UserKeychain.delete(key: UserInfo.saveKey)
    }
    
    func update() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
            UserKeychain.update(key: UserInfo.saveKey, data: data)
        } catch  {
            ZFPrint("archive update failed")
        }
    }
    
    class func queryInfo() -> UserInfo? {
        if let data = UserKeychain.query(key: UserInfo.saveKey) {
            do {
                let info = try NSKeyedUnarchiver.unarchivedObject(ofClass: UserInfo.self, from: data)
                return info
            } catch  {
                ZFPrint("unarchive failed")
            }
            
//            return NSKeyedUnarchiver.unarchiveObject(with: data) as? UserInfo
        }
        return nil
    }
}

class CodUserInfo: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    var id: String
    var name: String
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: CodingKeys.id)
        try container.encodeIfPresent(name, forKey: CodingKeys.name)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: CodingKeys.id) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: CodingKeys.name) ?? ""
    }
    
    func saveCache(model: CodUserInfo) {
        let filePath = CommonFunction.getDocumentFileUrl().appendingPathComponent("userCache", conformingTo: .fileURL)
        
        do {
            let archiver = NSKeyedArchiver(requiringSecureCoding: false)
            archiver.outputFormat = .binary
            
            try archiver.encodeEncodable(model, forKey: NSKeyedArchiveRootObjectKey)
            archiver.finishEncoding()
            try archiver.encodedData.write(to: filePath)
        } catch let error {
            
        }
    }
    
    func getCache() -> CodUserInfo? {
        //iOS 14+
        let filePath = CommonFunction.getDocumentFileUrl().appendingPathComponent("userCache", conformingTo: .fileURL)
        
        guard let data = try? Data(contentsOf: filePath) else { return nil }
        
        do {
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            unarchiver.requiresSecureCoding = false
            let cacheModel = unarchiver.decodeDecodable(CodUserInfo.self, forKey: NSKeyedArchiveRootObjectKey)
            return cacheModel
        } catch let error {
            return nil
        }
    }
}
