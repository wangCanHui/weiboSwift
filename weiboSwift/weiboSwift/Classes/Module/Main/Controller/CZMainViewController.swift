//
//  CZTabBarController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/26.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor.orangeColor()
        
        // 1. 添加首页
        addChildViewController(CZHomeViewController(), title: "首页", normalImgName: "tabbar_home")
        // 2. 添加信息
        addChildViewController(CZMessageViewController(), title: "信息", normalImgName: "tabbar_message_center")
        // 3. 添加中间按钮
        addChildViewController(UITableViewController(), title: "", normalImgName: "sb")
        // 4. 添加发现
        addChildViewController(CZDiscoverViewController(), title: "发现", normalImgName: "tabbar_discover")
        // 5. 添加我
        addChildViewController(CZProfileViewController(), title: "我", normalImgName: "tabbar_profile")
    }
    
    /**
    设置UITabBarController的子控制器
    
    :param: tableVc       子控制器
    :param: title         tabBarItem的标题
    :param: normalImgName tabBarItem的图片
    */
    func addChildViewController(tableVc:UITableViewController,title:String,normalImgName:String){
        
        // 设置标题,不能在包装成UINavigationController之后再设置标题，否则没有效果
        tableVc.title = title
        // 包装成UINavigationController
        let nav = UINavigationController(rootViewController: tableVc)
        // 设置标题
//        nav.title = title
        // 设置图片
        nav.tabBarItem.image = UIImage(named: normalImgName)
        // 添加到UITabBarController中
        addChildViewController(nav)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated) // 必须调用父类方法，否则
        
        let count = 5
        let btnW = self.tabBar.bounds.width / CGFloat(count)
        let btnH = self.tabBar.bounds.height
        let btn = composeButton
        btn.frame = CGRectMake(btnW*2, 0, btnW, btnH)
    }
    
    /// 撰写按钮单击事件
    func composeButtonClick(){
        print(__FUNCTION__)
    }
    
    // MARK: - 懒加载
    // 撰写按钮
    lazy var composeButton: UIButton = {
        let btn = UIButton()
        // 设置图片
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        // 设置背景图片
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        // 添加单击事件
        btn.addTarget(self, action: "composeButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.tabBar.addSubview(btn)
        
        return btn
    }()

    
}
