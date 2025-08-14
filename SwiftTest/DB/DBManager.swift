//
//  DBManager.swift
//  SwiftTest
//
//  Created by lezhi on 2018/1/4.
//  Copyright © 2018年 ZhangLiang. All rights reserved.
//

import UIKit
import SQLite

class DBManager: NSObject {
    private var myDb: Connection!
    private let testDb = Table("testDb") //table name
    private let user_id = Expression<String>(value: "user_id")
    let user_name = Expression<String>(value: "user_name")
//    private let user_age = Expression<Int64>(value: "user_age")
    
    override init() {
        super.init()
        self.connectDatabase()
    }
    
    func connectDatabase() {
        let dbPath = NSHomeDirectory() + "/Documents" + "/testDb.sqlite"
        print("++ dbPath is \(dbPath)")
        do {
            myDb = try Connection(dbPath)
            print("与数据库建立连接 成功")
        } catch {
            print("与数据库建立连接 失败：\(error)")
        }
    }
    
    func creatTable() {
        do {
            try myDb.run(testDb.create(block: { (table) in
//                table.column(user_id, primaryKey: .autoincrement)
                table.column(user_name)
//                table.column(user_age)
            }))
            print("创建表 testDb 成功")
        } catch {
            print("创建表 testDb 失败：\(error)")
        }
    }
    
    func readUser(userId: Int64) {
        
        for user in try! myDb.prepare(testDb.filter(user_id == "\(userId)")) {
            print("++++ \(user)")
        }
    }
    
    func insertUser(userId: Int64, name: String, age: Int64) {
        do {
            let insert = testDb.insert(user_id <- "\(userId)", user_name <- name)
            try myDb.run(insert)
        } catch {
            print("insert error")
        }
    }
    
    func updateUser(userId: Int64, userName: String, age: Int64) {
        let user = testDb.filter(user_id == "\(userId)")
        do {
            if try myDb.run(user.update(user_name <- userName)) > 0 {
                print("table 更新成功")
            }else{
                print("update item not found in table")
            }
        } catch  {
            print("table 更新失败")
        }
    }
    
    func deleteUser(userId: Int64) {
        let user = testDb.filter(user_id == "\(userId)")
        do {
            if try myDb.run(user.delete()) > 0 {
                print("table 删除成功")
            }else{
                print("delete item not found in table")
            }
        } catch  {
            print("table 删除失败")
        }
    }
}
