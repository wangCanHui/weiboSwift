//
//  CZOauthViewController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/28.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
import SVProgressHUD

class CZOauthViewController: UIViewController {

    override func loadView() {
        view = webView
        // 设置代理
        webView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSURLRequest(URL: CZNetworkTools.sharedInstance.oauthUrl())
        // 请求用户授权Token
        webView.loadRequest(request)
        
    }
    
    /// 关闭控制器
    func close(){
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var webView = UIWebView()
}

// MARK: - 扩展 CZOauthViewController 实现 UIWebViewDelegate 协议
extension CZOauthViewController: UIWebViewDelegate{
    
    /// 开始加载请求
    func webViewDidStartLoad(webView: UIWebView) {
        // 显示正在加载
        // showWithStatus 不主动关闭,会一直显示
        SVProgressHUD.showWithStatus("拼命加载中...", maskType: SVProgressHUDMaskType.Black)
    }
    
    /// 加载请求完毕
    func webViewDidFinishLoad(webView: UIWebView) {
        // 关闭
        SVProgressHUD.dismiss()
    }
    
    /// 询问是否加载 request
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.URL!.absoluteString
        print("urlString\(urlString)")
        // 如果不是回调地址则加载
        if !urlString.hasPrefix(CZNetworkTools.sharedInstance.redirect_uri){
            print("-------------------")
            return true
        }
        
        // 如果点击的是确定或取消截拦截不加载
        print("request.URL?.query\(request.URL?.query)")
        if  let query = request.URL?.query{
            print("query\(query)")
            let codeString = "code="
            if query.hasPrefix(codeString){
                // 确定
                // code=8b56fa06bebf7dc058696c2b2897767e
                // 转成NSString
               let queryStr = query as NSString
                
                // 截取code的值
                let code = queryStr.substringFromIndex(codeString.characters.count)
                print("code\(code)")
                // 获取授权过的Access Token
                loadAccessToken(code)
            }
            else{
                // 取消
                
            }
        }
        
        
        // 不进入回调地址页面
        return false
    }
    
    /**
    调用网络工具类去加载获取授权过的Access Token
    - parameter code: code
    */
    func loadAccessToken(code:String){
        CZNetworkTools.sharedInstance.loadAccessToken(code) { (result, error) -> () in
            if(error != nil || result == nil){
                SVProgressHUD.showWithStatus("网络不给力", maskType: SVProgressHUDMaskType.Black)
                // 延迟关闭. dispatch_after 没有提示,可以拖oc的dispatch_after来修改
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                    self.close()
                });
            }
            print("result:\(result)")
            
            // 把result字典里面的数据转化为CZUserAccount模型
            let account = CZUserAccount.init(dict: result!)
            
            // 把模型保存到沙盒
            account.saveAccount()
            
            print("account:\(account)")
            
            SVProgressHUD.dismiss()
        }
        
    }
    
    
}