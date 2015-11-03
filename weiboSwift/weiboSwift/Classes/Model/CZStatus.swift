//
//  CZStatus.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/31.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

enum CZStatusCellIdentifier: String {
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
}

class CZStatus: NSObject {
    /// 微博创建时间
    var created_at: String?
    
    /// 字符串型的微博ID
    var idstr: String?
    
    /// 微博信息内容
    var text: String?
    
    /// 微博来源
    var source: String?
    
    /// 微博的配图
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            // 当字典转模型,给pic_urls赋值的时候,将数组里面的url转成NSURL赋值给storePictureURLs
            
            // 判断有没有图片
            let count = pic_urls?.count ?? 0
            // 没有图片,直接返回
            if count == 0 {
                return
            }
            // 有图片
             // 创建storePictureURLs
            storePictureUrls = [NSURL]()
            for dict in pic_urls! {
                if let urlStr = dict["thumbnail_pic"] as? String {
                    let url = NSURL(string: urlStr)
                    storePictureUrls?.append(url!)
                }
            }
            
        }
    }
    /// 返回 微博的配图 对应的URL数组
    var storePictureUrls: [NSURL]?
    
    /// 如果是原创微博,就返回原创微博的图片,如果是转发微博就返回被转发微博的图片
    /// 计算型属性,
    var pictureUrls: [NSURL]? {
        get {
            // 判断:
            // 1.原创微博: 返回 storePictureURLs
            // 2.转发微博: 返回 retweeted_status.storePictureURLs
            return retweeted_status == nil ? storePictureUrls : retweeted_status!.storePictureUrls
        }
    }
    
    /// 用户模型
    var user: CZUser?
    
    /// 被转发微博
    var retweeted_status: CZStatus?
    
    /// 缓存行高
    var rowHeight: CGFloat?
    
    // 根据模型里面的retweeted_status来判断是原创微博还是转发微博
    /// 返回微博cell对应的Identifier
    func cellID() -> String {
         // retweeted_status == nil表示原创微博
        return retweeted_status == nil ? CZStatusCellIdentifier.NormalCell.rawValue : CZStatusCellIdentifier.ForwardCell.rawValue
    }
    
    /// 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    // KVC赋值每个属性的时候都会调用
    override func setValue(value: AnyObject?, forKey key: String) {
        // 判断user赋值时, 自己字典转模型
        //        print("key:\(key), value:\(value)")
        if key == "user" {
            if let dict = value as? [String: AnyObject] {
                // 字典转模型
                // 赋值
                user = CZUser(dict: dict)
                // 一定要return
               
                return
            }
        } else if key == "retweeted_status" {
            if let dict = value as? [String: AnyObject] {
                // 字典转模型
                // 赋值
                retweeted_status = CZStatus(dict: dict)
            }
            return
        }
        
        return super.setValue(value, forKey: key)
    }
    
    /// 字典的key在模型里面找不到对应的属性,防止报错
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String {
        let keys = ["created_at", "idstr", "text", "source", "pic_urls", "user","pictureUrls"]
        // 数组里面的每个元素,依据属性找到对应的value,拼接成字典
        // \n 换行, \t table
        return "\n\t微博模型：\(dictionaryWithValuesForKeys(keys))"
    }
    
    /// 加载微博数据
    /// 没有模型对象就能加载数据
    class func loadStatus(finished: (statuses: [CZStatus]?,error: NSError?) -> Void) {
        CZNetworkTools.sharedInstance.loadStatus { (result, error) -> Void in
            if  error != nil {
                print("error:\(error)")
                // 通知调用者
                finished(statuses: nil, error: error)
                return
            }
            // 判断是否有数据
            if let dicts = result!["statuses"] as? [[String: AnyObject]] // [[String: AnyObject]]表示字典数组，即数组中的元素是[String: AnyObject]类型的字典
            {
                // 有数据,创建模型数组
                var statuses = [CZStatus]()
                
                for dict in dicts {
                    let status = CZStatus(dict: dict)
                    statuses.append(status)
                }
                // 字典转模型完成
                // 通知调用者
                finished(statuses: statuses, error: nil)
            }
            else {
                // 没有数据,通知调用者
                finished(statuses: nil, error: nil)
            }
            
        }
    }
    
    
}
