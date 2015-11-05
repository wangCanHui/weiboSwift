//
//  AppDelegate.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/26.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // 设置全局的属性，今早设置
        setupAppearance()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let viewVC = UIViewController()
        viewVC.view.backgroundColor = UIColor.redColor()
        
//        let tabBarC = CZMainViewController()
        
//        window!.rootViewController = CZNewFeatureViewController()
        window!.rootViewController = defaultController()
        
        window!.makeKeyAndVisible()
        
        return true
    }
    
    private func defaultController() -> UIViewController {
        // 判断是否登录
        // 每次都需要判断
        if !CZUserAccount.userLogin {
            print("用户未登录")
            return CZMainViewController()
        }
        // 判断是否是新版本
        return isNewVersion() ? CZNewFeatureViewController() : CZWelcomeViewController()
    }
    
    
    /// 判断是否是新版本
    private func isNewVersion() -> Bool {
        // 获取当前的版本号
        let versionStr = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        let currentVersion = Double(versionStr)!
        print("currentVersion\(currentVersion)")
        
        // 获取到之前的版本号
        let sandboxVersionKey = "sandboxVersionKey"
        let sandboxVersion = NSUserDefaults.standardUserDefaults().doubleForKey(sandboxVersionKey)
        
        // 保存当前版本号
        NSUserDefaults.standardUserDefaults().setDouble(currentVersion, forKey: sandboxVersionKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        if currentVersion > sandboxVersion {
            print("是新版本")
        }
        
        // 对比
        return currentVersion > sandboxVersion
        
    }
    
    // MARK: - 切换根控制器
    
    /**
    切换根控制器
    - parameter isMain: true: 表示切换到MainViewController, false: welcome
    */

    func switchRootController(isMain: Bool) {
        window?.rootViewController = isMain ? CZMainViewController() : CZWelcomeViewController()
    }
    
    private func setupAppearance() {
         // 设置全局导航栏文字颜色,尽早设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
    }

}

