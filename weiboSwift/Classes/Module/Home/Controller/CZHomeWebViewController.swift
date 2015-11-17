//
//  CZHomeWebViewController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/11.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
import SVProgressHUD

class CZHomeWebViewController: UIViewController , UIWebViewDelegate {
    // MARK: - 属性
    /// url地址
    var url: NSURL?
    
    override func loadView() {
        view = webView
        webView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if url != nil {
            let request = NSURLRequest(URL: url!)
            // 开始加载网址
            webView.loadRequest(request)
        }

    }
    
    // MARK: - UIWebViewDelegate
     // 已经开始加载内容
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showWithStatus("正在加载...", maskType: SVProgressHUDMaskType.None)
    }
     // webView加载完毕
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    // MARK: - 懒加载webView
    private lazy var webView = UIWebView()
}
