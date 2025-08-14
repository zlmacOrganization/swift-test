//
//  SwiftDataTest.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/11/15.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
class User: CustomStringConvertible {
    var id: UUID
    var name: String

    init(name: String) {
        id = UUID()
        self.name = name
    }

    var description: String {
        return "\(name)—"
    }
}

@available(iOS 17, *)
class DataTools {
    static var shared = DataTools()
    var container: ModelContainer?
    var context: ModelContext?
    
    init() {
        do {
            container = try ModelContainer(for: User.self)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            print(error)
        }
    }
    
    // 增加
    func insert(user: User) {
        context?.insert(user)
    }

    // 删除
    func delete(user: User) {
        context?.delete(user)
    }

    // 修改
    func update(user: User, newName: String) {
        user.name = newName
    }
    
    func select(completionHandler: @escaping ([User]?, Error?) -> Void) {
        let descriptor = FetchDescriptor<User>(sortBy: [SortDescriptor(\.name)])
        
        do {
            let models = try context?.fetch(descriptor)
            completionHandler(models, nil)
        } catch {
            completionHandler(nil, error)
        }
    }
    
    // 保存
    func save() {
        do {
            try context?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
