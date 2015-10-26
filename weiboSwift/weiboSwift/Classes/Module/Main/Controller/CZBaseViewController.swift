//
//  CZBaseViewController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/26.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZBaseViewController: UITableViewController {

    // 当实现这个方,并且给view设置值,不会再从其他地方加载view.xib storyboard
    /*
    在 loadView，如果:
    1.设置view的值,使用设置的view
    2.super.loadView() 创建TableView
    
    */
    let userLogin = false
    
    override func loadView() {
        userLogin ? super.loadView() : setupVisitorView()
    }
   
    func setupVisitorView(){
        view = CZVisitorView()
        view.backgroundColor = UIColor.whiteColor()
    }
    
}
