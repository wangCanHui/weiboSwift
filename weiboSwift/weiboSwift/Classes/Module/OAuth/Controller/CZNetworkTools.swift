//
//  CZNetworkTools.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/29.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
import AFNetworking

class CZNetworkTools: AFHTTPSessionManager {

    /// 单例
    static let sharedInstance: CZNetworkTools = {
        let urlString = "https://api.weibo.com/"
        let tool = CZNetworkTools(baseURL: NSURL(string: urlString))
        
        // 往AFNetworking库中添加"text/plain"解析类型,微博数据的返回类型
         tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tool
    }()
    
    // MARK: - OAtuh授权
    /// 申请应用时分配的AppKey
    private let client_id = "697773161"
    
    /// 申请应用时分配的AppSecret
    private let client_secret = "f28a66a16479996a041c0d31d2d895bc"
    
    /// 请求的类型，填写authorization_code
    private let grant_type = "authorization_code"
    
    /// 回调地址
    let redirect_uri = "http://www.baidu.com/"
    
    // OAtuhURL地址
    
    func oauthUrl() -> NSURL{
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        return NSURL(string: urlString)!
    }
    
    // 使用闭包回调
    // MARK: - 加载AccessToken
    /// 加载AccessToken
    func loadAccessToken(code:String,finished:(result: [String: AnyObject]?,error: NSError?) -> ()){
        
        // url
        let urlString = "oauth2/access_token"
        // NSObject
        // AnyObject, 任何 class
        // 参数
        let parameters = [  //字典用[]
            "client_id": client_id,
            "client_secret": client_secret,
            "grant_type": grant_type,
            "code": code,
            "redirect_uri": redirect_uri
        ]
        
        POST(urlString, parameters: parameters, success: { (_, result) -> Void in
            
            finished(result: result as? [String:AnyObject],error:nil)
            
            }) { (_, error:NSError) -> Void in
                finished(result:nil,error:error)
        }
        
    }
}
