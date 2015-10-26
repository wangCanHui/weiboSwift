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

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let viewVC = UIViewController()
        viewVC.view.backgroundColor = UIColor.redColor()
        
        let tabBarC = CZTabBarController()
        
        window!.rootViewController = tabBarC
        
        window!.makeKeyAndVisible()
        
        return true
    }

    


}

