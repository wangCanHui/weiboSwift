//
//  CZStatus.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/31.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
import SDWebImage

enum CZStatusCellIdentifier: String {
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
}

class CZStatus: NSObject {
    /// 微博创建时间
    var created_at: String?
    
    /// 字符串型的微博ID
    var id: Int = 0
    
    /// 微博信息内容
    var text: String?
    
    /// 微博来源
    var source: String?

    /// 微博的配图，此属性前不能加private，如果加的话使用KVC字典转模型的时候就找不到这个属性了；
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
            // 创建storePictureUrls,保存缩略图的url地址
            storePictureUrls = [NSURL]()
            // 保存大图的url地址
            largeStorePictureUrls = [NSURL]()
            for dict in pic_urls! {
                if let urlStr = dict["thumbnail_pic"] as? String {
                    // 有url地址,创建缩略图NSURL
                    let url = NSURL(string: urlStr)
                    storePictureUrls?.append(url!)
                    
                    // 创建大图NSURL, 将小图的url地址中的 thumbnail 替换为 large
                    let largeUrlStr = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                    largeStorePictureUrls?.append(NSURL(string: largeUrlStr)!)
                    
                }
            }
            
        }
    }
    /// 返回 微博的配图 对应的URL数组
    private var storePictureUrls: [NSURL]?
    
    /// 返回 微博的配图 对应的大图URL数组
    private var largeStorePictureUrls: [NSURL]?
    
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
    
    /// 如果是原创微博,就返回原创微博的大图URL,如果是转发微博就返回被转发微博的大图URL
    /// 计算型属性,
    var largePictureUrls: [NSURL]? {
        get {
            // 判断:
            // 1.原创微博: 返回 largeStorePictureUrls
            // 2.转发微博: 返回 retweeted_status.largeStorePictureUrls
            return retweeted_status == nil ? largeStorePictureUrls : retweeted_status!.largeStorePictureUrls
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
        let keys = ["created_at", "id", "text", "source", "pic_urls", "user","pictureUrls"]
        // 数组里面的每个元素,依据属性找到对应的value,拼接成字典
        // \n 换行, \t table
        return "\n\t微博模型：\(dictionaryWithValuesForKeys(keys))"
    }
    
    /// 加载微博数据
    /// 没有模型对象就能加载数据
    class func loadStatus(since_id: Int,max_id: Int,finished: (statuses: [CZStatus]?,error: NSError?) -> Void) {
        CZNetworkTools.sharedInstance.loadStatus(since_id, max_id: max_id) { (result, error) -> Void in
            
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
//                    print("status\(status)")
                    statuses.append(status)
                }
                // 字典转模型完成
                // 缓存图片，通知调用者
                cacheWebImage(statuses, finished: finished)
//                finished(statuses: statuses, error: nil) 这里不能再回调了，在cacheWebImage方法最后回调
            }
            else {
                // 没有数据,通知调用者
                finished(statuses: nil, error: nil)
            }
            
        }
    }
    
    /// 缓存图片，通知调用者
    class func cacheWebImage(statuses:[CZStatus]?,finished: (statuses: [CZStatus]?,error: NSError?) -> Void) {
       // 创建任务组
        let group = dispatch_group_create()
        // 判断是否有模型
        guard let list = statuses else {
            // 没有模型
            return
        }
        // 记录缓存图片的大小
        var length = 0
        // 遍历模型
        for status in list {
            // 如果没有图片需要下载,接着遍历下一个
            let count = status.pictureUrls?.count ?? 0
            if count == 0 {
                // 没有图片,遍历下一个模型
                continue
            }
            
            if count == 1 {
                let url = status.pictureUrls![0]
                // 缓存图片
                // 在缓存之前放到任务组里面
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, _, _, _) -> Void in
                     // 离开组
                    dispatch_group_leave(group)
                     // 判断有没有错误
                    if error != nil {
                        print("下载图片出错:\(url)")
                        return
                    }
                    // 没有出错
//                    print("下载图片完成:\(url)")
                    // 记录下载图片的大小
                    if let imageData = UIImagePNGRepresentation(image) {
                        length += imageData.length
                    }
                    
                })
                
            }
            
        }
         // 所有图片都下载完,在通知调用者
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
//             print("所有图片下载完成,告诉调用者获取到了微博数据: 大小:\(length / 1024)")
            // 通知调用者,已经有数据
            finished(statuses: statuses, error: nil)
        }
        
    }
    
}
