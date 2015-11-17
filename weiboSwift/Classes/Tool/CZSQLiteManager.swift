//
//  SQLiteManager.swift
//  FMDB使用
//
//  Created by zhangping on 15/11/13.
//  Copyright © 2015年 zhangping. All rights reserved.
//

import UIKit

/*
    FMDatabase:
        一个FMDatabase表示一个数据库,通过这个对象来操作数据库增删改查
        在FMDB中除了查询,都称为update
        executeUpdate

        查询
        executeQuery

        一次性执行多条sql
        executeStatements

    FMDatabaseQueue:
        内部有一个queue和FMDatabase,建议使用FMDatabaseQueue
        inDatabase: 直接使用数据库
        inTransaction: 使用事务

    FMResultSet:
        查询结果集
*/

class CZSQLiteManager: NSObject {

    // 单例
    static let sharedManager = CZSQLiteManager()
    
    /// 数据库名称
    private let dbName = "status.db"
    
    let dbQueue: FMDatabaseQueue
    
    override init() {
        // document
        let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        
        // 数据库的完整路径
        let dbPath = (documentPath as NSString).stringByAppendingPathComponent(dbName)
        
        print("dbPath:\(dbPath)")
        
        // 创建 FMDatabaseQueue 对象, 如果数据库不存在就会创建数据库,自动打开数据库,并创建一个串行队列,后续操作数据库都使用这个对象
        dbQueue = FMDatabaseQueue(path: dbPath)
        
        super.init()
        
        createTable("T_Person")
    }
    
    /**
    创建表
    - parameter tbName: 表名称
    */
    func createTable(tbName: String) {
//        let sql = "CREATE TABLE IF NOT EXISTS \(tbName) ( \n" +
//            "id INTEGER NOT NULL, \n" +
//            "name TEXT, \n" +
//            "age INTEGER, \n" +
//            "height REAL, \n" +
//            "PRIMARY KEY(id) \n" +
//        ")"
        
        // 从文件加载sql
        let path = NSBundle.mainBundle().pathForResource("tables", ofType: "sql")!
        
        let sqls = try! String(contentsOfFile: path)
        
        // 执行sql
        dbQueue.inDatabase { (db) -> Void in
            // 执行sql
            if db.executeStatements(sqls) {
                print("创建数据表成功")
            } else {
                print("创建数据表失败")
            }
        }
    }
}
