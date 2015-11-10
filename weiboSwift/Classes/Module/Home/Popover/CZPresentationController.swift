//
//  CZPresentationController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/9.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

/*
presentedViewController:
展现的控制器(modal出来的控制器)

presentedView():
返回modal出来的控制器的view

containerView:
容器视图:存放modal出来的控制器的view

containerViewWillLayoutSubviews
容器视图布局的时候调用

presentationTransitionWillBegin
当将要modal时候会调用这个方法
*/

class CZPresentationController: UIPresentationController {
    // 容器视图将要布局
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
//        print("containerViewWillLayoutSubviews")
        // 容器视图背景改成灰色
        containerView?.backgroundColor = UIColor(white: 0, alpha: 0.2)
         // 创建手势
        let tap = UITapGestureRecognizer(target: self, action: "close")
        containerView?.addGestureRecognizer(tap)
        // 设置modal出来控制器的view的大小
        presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 300)
    }
    
    func close() {
        // 拿到modal出来的控制器
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
        // 让首页的title按钮转回去
        NSNotificationCenter.defaultCenter().postNotificationName("PopoverDismiss", object: self)
    }
    
    
}
