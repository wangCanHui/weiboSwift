//
//  CZHomeViewController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/26.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
import SVProgressHUD

class CZHomeViewController: CZBaseViewController {

    // MARK: - 属性
    /// 微博模型数组
    private var statuses: [CZStatus]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !CZUserAccount.userLogin {
            return
        }
        
        setupNavigationBar()
        prepareTableView()
        
        // TODO: 测试获取微博数据
        print("加载微博数据")
        CZStatus.loadStatus { (statuses, error) -> Void in
            if (error != nil){
                SVProgressHUD.showErrorWithStatus("加载微博数据失败,网络不给力", maskType: SVProgressHUDMaskType.Black)
                return
            }
            // 能到下面来说明没有错误
            if statuses == nil || statuses?.count == 0 {
                SVProgressHUD.showInfoWithStatus("没有新的微博数据", maskType: SVProgressHUDMaskType.Black)
                return
            }
            
            // 有微博数据
            self.statuses = statuses
            print("statuses:\(statuses)")
        }
    }
    
    private func prepareTableView() {
        // talbeView注册cell
        tableView.registerClass(CZStatusCell.self, forCellReuseIdentifier: "cell")
        // 设置预估行高
        tableView.estimatedRowHeight = 300
         // AutomaticDimension 根据约束自己来设置高度
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    // MARK: - 设置导航栏
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendsearch")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        // 获取用户名
        // ??:  如果?? 前面有值,拆包 赋值给 name,如果没有值 将?? 后面的内容赋值给 name
        let name = CZUserAccount.loadAccount()?.name ?? "无名"
        // 设置title
        let button = CZHomeTitleButton()
        
        button.setTitle(name, forState: UIControlState.Normal)
        button.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.sizeToFit()
        
        button.addTarget(self, action: "homeTitleButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.navigationItem.titleView = button
    }
    
    // OC可以访问 private方法
    @objc private func homeTitleButtonClick(button: CZHomeTitleButton) {
        button.selected = !button.selected
        
        var transform: CGAffineTransform?
        if button.selected {
            transform = CGAffineTransformMakeRotation(CGFloat(M_PI - 0.01))
        } else {
            transform = CGAffineTransformIdentity
        }
        
        // 动画
        UIView.animateWithDuration(0.25) { () -> Void in
            button.imageView?.transform = transform!
        }
        
        
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CZStatusCell
        // 设置cell的模型
        cell.status = self.statuses?[indexPath.row]
        
        return cell
    }

}
