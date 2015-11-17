//
//  CZStatusDAL.swift
//  GZWeibo05
//
//  Created by zhangping on 15/11/13.
//  Copyright © 2015年 zhangping. All rights reserved.
//

import UIKit

// 只负责加载数据,有可能从网络加载,也有可能从本地数据库加载

/*
    1. 先从本地数据库加载 *
    2. 本地数据库有数据,直接返回数据库中的数据
    3. 本地数据库有没有数据,调用网络工具类去网络加载数据
    4. 将网络返回的数据保存到数据库 *
    5. 返回数据
*/
class CZStatusDAL: NSObject {
    
    // 单例
    static let sharedInstance = CZStatusDAL()
    
    // 过期秒数
    private let clearDate: NSTimeInterval = 60 // 7 * 24 * 60 * 60
    
    // 清除过期的缓存数据
    func clearCacheData() {
        // 计算过期时间
        let overDate = NSDate(timeIntervalSinceNow: -clearDate)
        print("当前时间:\(NSDate())")
        print("过期时间:\(overDate)")
        
        // 日期格式化成sqlite数据库的日期格式
        let df = NSDateFormatter()
        
        // 设置格式     2015-11-13 15:56:02
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // 将过期时间转成sqlite时间字符串
        let overString = df.stringFromDate(overDate)
        
        // 生成sql语句
        let sql = "DELETE FROM T_Status WHERE createTime < '\(overString)'"
        
        print("清除数据sql:\(sql)")
        // 执行sql语句
        CZSQLiteManager.sharedManager.dbQueue.inDatabase { (db) -> Void in
            if db.executeUpdate(sql) {
                print("清除缓存数据成功")
            }
//            guard let result = db.executeQuery(sql) else {
//                print("查询失败")
//                return
//            }
//            
//            while result.next() {
//                let createTime = result.stringForColumn("createTime")
//                print("createTime:\(createTime)")
//            }
        }
    }
    
    /**
    加载微博数据,有可能从网络加载,也有可能从本地数据库加载
    */
    func loadStatus(since_id: Int, max_id: Int, finished: (array: [[String: AnyObject]]?, error: NSError?) -> ()) {
        // 1. 先从本地数据库加载 *
        loadCacheStatus(since_id, max_id: max_id) { (array) -> () in
            if array != nil && array?.count > 0 {
                // 2. 本地数据库有数据,直接返回数据库中的数据
                print("加载缓存数据:\(array?.count)")
                finished(array: array, error: nil)
                return
            }
            
            // 3. 本地数据库有没有数据,调用网络工具类去网络加载数据
            CZNetworkTools.sharedInstance.loadStatus(since_id, max_id: max_id, finished: { (result, error) -> () in
                if error != nil {
                    print("加载网络数据失败")
                    finished(array: nil, error: error)
                    return
                }
                
                // 有网络数据
                if let array = result?["statuses"] as? [[String: AnyObject]] {
                    // 4. 将网络返回的数据保存到数据库 *
                    self.saveStatus(array)
                    // 5. 返回数据
                    finished(array: array, error: nil)
                }
            })
        }
    }
    
    /// 先从本地数据库加载
    private func loadCacheStatus(since_id: Int, max_id: Int, finished: (array: [[String: AnyObject]]?) -> ()) {
        assert(CZUserAccount.loadAccount()?.uid != nil, "uid 为空")
        // 用户Id
        let userid = Int(CZUserAccount.loadAccount()!.uid!)!
        
        var sql = "SELECT statusId, status, userId FROM T_Status \n" +
        "WHERE userId = \(userid) \n"

        if since_id > 0 {
            sql += "AND statusId > \(since_id) \n"
        } else if max_id > 0 {
            sql += "AND statusId < \(max_id) \n"
        }
        
        sql += "ORDER BY statusId DESC \n" + "LIMIT 20;"
        
        print("加载缓存数据sql: \n\t \(sql)")
        
        // 执行sql语句加载数据
        CZSQLiteManager.sharedManager.dbQueue.inDatabase { (db) -> Void in
            
            // 从数据库加载数据
            guard let result = db.executeQuery(sql) else {
                print("加载缓存数据失败")
                finished(array: nil)
                return
            }
            
            // 存放数据库加载到的微博字典数据
            var statuses = [[String: AnyObject]]()
            
            // 获取数据
            while result.next() {
                // 获取保存在数据库中的微博字符串
                let statusString = result.stringForColumn("status")
                
                // String -> NSData -> JSON
                if let statusData = statusString.dataUsingEncoding(NSUTF8StringEncoding) {
                    
                    let json = try! NSJSONSerialization.JSONObjectWithData(statusData, options: NSJSONReadingOptions(rawValue: 0))
                    
                    // 转成字典
                    let dict = json as! [String: AnyObject]
                    
                    // 添加到数组
                    statuses.append(dict)
                }
            }
            
            // 已经得到需要的数据
            finished(array: statuses)
        }
    }
    
    /**
    将网络返回的数据保存到数据库
    - parameter statuses: 网络返回的微博数据
    */
    private func saveStatus(statuses: [[String: AnyObject]]) {
        assert(CZUserAccount.loadAccount()?.uid != nil, "uid 为空")
        
        let userid = Int(CZUserAccount.loadAccount()!.uid!)!
        
        // 生成sql语句
        let sql = "INSERT INTO T_Status (statusId, status, userId) VALUES(?, ?, ?)"
        
        // 通过事务保存微博数据
        CZSQLiteManager.sharedManager.dbQueue.inTransaction { (db, rollback) -> Void in
            // 遍历微博数组,获取每一条微博的id
            for dict in statuses {
                // 获取微博id
                let statusId = dict["id"] as! Int
                
                // 不能直接往数据库存放字典, 将字典转成String
                // 字典(json) -> NSData -> String
                let data = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
                
                // 转成String
                let statusString = String(data: data, encoding: NSUTF8StringEncoding)!
                
                // 添加微博数据到数据库
                if db.executeUpdate(sql, statusId, statusString, userid) {
//                    print("添加微博数据成功")
                } else {
                    print("添加微博数据失败")
                    rollback.memory = true
                    break
                }
            }
        }
        
        print("缓存数据,添加:\(statuses.count) 条数据到数据库")
    }
}
