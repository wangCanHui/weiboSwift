//
//  CZBaseViewController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/26.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZBaseViewController: UITableViewController{

    // 当实现这个方,并且给view设置值,不会再从其他地方加载view.xib storyboard
    /*
    在 loadView，如果:
    1.设置view的值,使用设置的view
    2.super.loadView() 创建TableView
    
    */
    let userLogin = CZUserAccount.userLogin
    
    override func loadView() {
        userLogin ? super.loadView() : setupVisitorView()
        
        
    }
   
    func setupVisitorView(){

        let vistorView = CZVisitorView()
        view = vistorView
        // 设置代理
        vistorView.visitorViewDelegate = self
        
        
        // 设置导航栏
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorViewRegisterBtnClick")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorViewLoginBtnClick")
        
        if self is CZHomeViewController{
            
            vistorView.startIconViewAnimitation()
            // 监听应用退到后台,和进入前台
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
            
        }else if self is CZMessageViewController{
            vistorView.setupVisitorView("visitordiscover_image_message", message: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
        }else if self is CZDiscoverViewController{
            vistorView.setupVisitorView("visitordiscover_image_message", message: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
        }else if self is CZProfileViewController{
            vistorView.setupVisitorView("visitordiscover_image_profile", message: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
        }
        
    }
    
    // MARK: - 通知方法
    func didEnterBackground(){
        // 暂停动画，(view as! CZVisitorView)是把view对象强转为CZVisitorView类型的，因为在setupVisitorView()方法里面已经给把CZVisitorView类的对象赋值给了当前控制器的view
        (view as! CZVisitorView).pauseAnimation()
    }
    
    func didBecomeActive(){
        // 继续动画
        (view as! CZVisitorView).resumeAnimation()
    }
}

// MARK: - 扩展 CZBaseViewController 实现 CZVisitorViewDelegate 协议
//相当于 category, 方便代码的管理

extension CZBaseViewController: CZVisitorViewDelegate {
    // MARK: - 代理方法
    func visitorViewRegisterBtnClick() {
        print(__FUNCTION__)
        
    }
    
    func visitorViewLoginBtnClick() {
        // 加载授权界面
        let oauthVc = CZOauthViewController()
        let nav = UINavigationController(rootViewController: oauthVc)
        presentViewController(nav, animated: true, completion: nil)
         print(__FUNCTION__)
    }
    
}
