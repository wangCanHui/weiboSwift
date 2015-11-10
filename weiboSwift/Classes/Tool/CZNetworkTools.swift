//
//  CZNetworkTools.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/29.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
import AFNetworking

// MARK: - 网络错误枚举
enum CZNetworkError: Int {
    case emptyToken = -1
    case emptyUid = -2
    // 枚举里面可以有属性
    var descirption: String {
        get{
            // 根据枚举的类型返回对应的错误
            switch self {
            case .emptyToken:
            return "accecc token 为空"
            case .emptyUid:
            return "uid 为空"
            }
        }
    }
    // 枚举可以定义方法
    func error() -> NSError {
        return NSError(domain: "netwotk.error", code: rawValue, userInfo: ["errorDescription": descirption])
    }
}

class CZNetworkTools: NSObject {

    // 属性
    private var afnManager: AFHTTPSessionManager
    
    /// 创建单例
    static let sharedInstance: CZNetworkTools = CZNetworkTools()
    
    override init() {
        let urlString = "https://api.weibo.com/"
        afnManager = AFHTTPSessionManager(baseURL: NSURL(string: urlString)) // 此处使用baseURL来初始化AFHTTPSessionManager对象，所以在下面的网络请求中，可以不用写这个baseURL部分
//        AFJSONResponseSerializer ，点到这里类里面，可以看到AFN可以解析的响应类型
        afnManager.responseSerializer.acceptableContentTypes?.insert("text/plain") //"text/plain"是新浪微博返回的数据类型，AFN没有这种解析类型，所以要添加
    }
    
//    static let sharedInstance: CZNetworkTools = {
//        let urlString = "https://api.weibo.com/"
//        /*
//        @param url The base URL for the HTTP client.
//        @return The newly-initialized HTTP client
//        public convenience init(baseURL url: NSURL?) 便利创建对象
//        */
//        let tool = CZNetworkTools(baseURL: NSURL(string: urlString))
//        
//        // 往AFNetworking库中添加"text/plain"解析类型,微博数据的返回类型
//         tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
//        return tool
//    }()
    
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
    func loadAccessToken(code: String,finished: netWorkFinishedCallBack){
        
        // url,不用加域名也可以，会自动和单列方法中的urlString拼接
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
        
        afnManager.POST(urlString, parameters: parameters, success: { (_, result) -> Void in
            // 成功回调
            finished(result: result as? [String:AnyObject],error:nil)
            
            }) { (_, error:NSError) -> Void in
                // 失败回调
                finished(result:nil,error:error)
        }
        
    }
    
    // 类型别名 = typedefined
    // 网络请求完成回调
    typealias netWorkFinishedCallBack = (result: [String: AnyObject]?,error: NSError?) -> Void
    
    // MARK: - 获取用户信息
    
    func loadUserInfo(finished: netWorkFinishedCallBack) {

        
        // 守卫,和可选绑定相反
        // 参数：parameters 代码块里面和外面都能使用
        guard var parameters = tokenDict() else {
            print("accessToken为空")
            let error = CZNetworkError.emptyToken.error()
            // 回调
            finished(result: nil, error: error)
            return
        }
        
        // 判断uid
        if CZUserAccount.loadAccount()?.uid == nil {
            print("uid为空")
            let error = CZNetworkError.emptyUid.error()
            // 回调
            finished(result: nil, error: error)
            return
        }
        
        // url
        let urlString = "https://api.weibo.com/2/users/show.json"
        
         // 添加元素
        parameters["uid"] = CZUserAccount.loadAccount()!.uid!

        // 发送请求,注意参数parameters不能是可选的，所以上面parameters的value都要强制拆包，而且已经肯定是有值的
        requestGET(urlString, parameters: parameters, finished: finished)
    }
    
    /// 判断access token是否有值,没有值返回nil,如果有值生成一个字典
    func tokenDict() -> [String: AnyObject]? {
       return CZUserAccount.loadAccount()?.access_token == nil ? nil : ["access_token": CZUserAccount.loadAccount()!.access_token!]
    }
    
    // MARK: - 获取微博数据
    func loadStatus(since_id: Int,max_id: Int,finished: netWorkFinishedCallBack) {
        guard var parameters = tokenDict() else {
            print("accessToken为空")
            let error = CZNetworkError.emptyToken.error()
            // 回调
            finished(result: nil, error: error)
            return
        }
        // access token 有值
        let urlString = "2/statuses/home_timeline.json"
        
        // 添加参数 since_id和max_id
        // 判断是否有传since_id,max_id
        if since_id > 0{
            parameters["since_id"] = since_id
        }else if max_id > 0 {
            parameters["max_id"] = max_id - 1  // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        }
        
        // 发送请求
        requestGET(urlString, parameters: parameters, finished: finished)
        
        // 网络不给力,加载本地数据
//        loadLocalStatus(finished)

    }
    
    private func loadLocalStatus(finished:netWorkFinishedCallBack) {
        // 获取路径
        let path = NSBundle.mainBundle().pathForResource("statuses", ofType: "json")
        // 加载文件数据
        let data = NSData(contentsOfFile: path!)
        
        // 转成json
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
            
            finished(result: json as? [String: AnyObject], error: nil)
        }catch {
            print("出异常了")
        }
        
    }
    // MARK: - 发布微博
    /**
    发布微博
    - parameter image:   微博图片,可能有可能没有
    - parameter status:   微博文本内容
    - parameter finished: 回调闭包
    */
    func sendStatus(image: UIImage?,status: String,finished:netWorkFinishedCallBack) {
        // 判断token
        guard var parameters = tokenDict() else {
            // 能到这里来说明token没有值
            
            // 告诉调用者
            finished(result: nil, error: CZNetworkError.emptyToken.error())
            return
        }
         // token有值, 拼接参数
        parameters["status"] = status
        // 判断是否有图片
        if (image != nil) {
            // 有图片,发送带图片的微博
            let urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
            afnManager.POST(urlString, parameters: parameters, constructingBodyWithBlock: { (formData) -> Void in
                let data = UIImagePNGRepresentation(image!)
                // data: 上传图片的2进制
                // name: api 上面写的传递参数名称 "pic"
                // fileName: 上传到服务器后,保存的名称,没有指定可以随便写
                // mimeType: 资源类型:
                // image/png
                // image/jpeg
                // image/gif
                formData.appendPartWithFileData(data!, name: "pic", fileName: "sb", mimeType: "image/png")
                }, success: { (_, result) -> Void in
                    finished(result: result as? [String: AnyObject], error: nil)
                }, failure: { (_, error) -> Void in
                    finished(result: nil, error: error)
            })
        } else {
            // url
            let urlString = "2/statuses/update.json"
            // 没有图片
            afnManager.POST(urlString, parameters: parameters, success: { (_, result) -> Void in
                finished(result: result as? [String: AnyObject], error: nil)
                }, failure: { (_, error) -> Void in
                finished(result: nil, error: error)
            })
        }
    }
    
    // MARK: - 封装AFN.GET
    func requestGET(urlString: String, parameters: AnyObject?,finished:(result: [String: AnyObject]?,error: NSError?) -> Void) {
        
        afnManager.GET(urlString, parameters: parameters, success: { (_, result) -> Void in
            // 成功回调
            finished(result: result as? [String : AnyObject], error: nil)
            
            }) { (__, error) -> Void in
                // 失败回调
                finished(result: nil, error: error)
                
        }

    }
    
}
