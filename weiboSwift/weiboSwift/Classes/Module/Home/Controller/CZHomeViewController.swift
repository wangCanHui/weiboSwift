//
//  CZHomeViewController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/26.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
import AFNetworking
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
        
        // 默认高度60,宽度是屏幕的宽度
        // 自定义 UIRefreshControl,在 自定义的UIRefreshControl添加自定义的view
        refreshControl = CZRefreshControl()
        // 添加下拉刷新响应事件
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        
        // 调用beginRefreshing，使第一次进入首页时显示刷新,但是不会触发 ValueChanged 事件,只会让刷新控件进入刷新状态
        refreshControl?.beginRefreshing()
        // 代码触发 refreshControl 的 ValueChanged 事件
        refreshControl?.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
    }
    
    /*
    since_id	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    max_id	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    */
    
    /// 下拉刷新响应事件
   @objc private func loadData() {
        // TODO: 测试获取微博数据
        print("加载微博数据")
        // 默认下拉刷新,获取id最大的微博, 如果没有数据,就默认值0,加载20条微博数据
        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        
        // 如果上拉菊花正在转,表示 上拉加载更多数据
        if pullUpView.isAnimating() {
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
        
        
        
        CZStatus.loadStatus(since_id, max_id: max_id) { (statuses, error) -> Void in
             // 关闭下拉刷新控件
            self.refreshControl?.endRefreshing()
             // 将上拉菊花停止
            self.pullUpView.stopAnimating()
          
            if (error != nil){
                SVProgressHUD.showErrorWithStatus("加载微博数据失败,网络不给力", maskType: SVProgressHUDMaskType.Black)
                return
            }
             // 能到下面来说明没有错误
            // 下拉刷新,显示加载了多少条微博
            if since_id > 0 {
                let count = statuses?.count ?? 0
                self.showTipView(count)
            }
           
            if statuses == nil || statuses?.count == 0 {
                SVProgressHUD.showInfoWithStatus("没有新的微博数据", maskType: SVProgressHUDMaskType.Black)
                return
            }
            // 判断如果是下拉刷新,加获取到数据拼接在现有数据的前
            if since_id > 0 {
                print("下拉刷新获取\(statuses?.count)条微博")
                self.statuses = statuses! + self.statuses!
            }else if max_id > 0 {
                print("上拉刷新获取\(statuses?.count)条微博")
                self.statuses = self.statuses! +  statuses!
            }else {
                // 首次进入首页有微博数据,赋值给空的微博模型数组
                self.statuses = statuses
                print("首次进入首页获取\(statuses?.count)条微博")            }
            
        }

    }
    
    /// 显示下拉刷新加载了多少条微博
    private func showTipView(count: Int) {
        let tipLabel = UILabel(fontSize: 16, textColor: UIColor.whiteColor())
        let tipLabelHeight:CGFloat = 44
        tipLabel.frame = CGRect(x: 0, y: -20 - tipLabelHeight, width: UIScreen.width(), height: tipLabelHeight)
        tipLabel.textAlignment = NSTextAlignment.Center
        tipLabel.backgroundColor = UIColor.orangeColor()
        
        tipLabel.text = count == 0 ? "没有新的微博" : "加载了 \(count) 条微博"
        
        // 导航栏是从状态栏下面开始
        // 添加到导航栏最下面
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        // 开始动画
        UIView.animateWithDuration(0.75, animations: { () -> Void in
            // 让动画反过来执行
            //            UIView.setAnimationRepeatAutoreverses(true)
            
            // 重复执行
            //            UIView.setAnimationRepeatCount(5)
            tipLabel.frame.origin.y = tipLabelHeight
            }) { (_) -> Void in
                
                UIView.animateWithDuration(0.7, delay: 0.3, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    
                    tipLabel.frame.origin.y = -20 - tipLabelHeight
                    
                    }, completion: { (_) -> Void in
                        
                        tipLabel.removeFromSuperview()
                })
        }
    }
    
    private func prepareTableView() {
         // 添加footView,上拉加载更多数据的菊花
        tableView.tableFooterView = pullUpView
        // talbeView注册cell
         // 原创微博cell
        tableView.registerClass(CZStatusNormalCell.self, forCellReuseIdentifier: CZStatusCellIdentifier.NormalCell.rawValue)
         // 转发微博cell
        tableView.registerClass(CZStatusForwardCell.self, forCellReuseIdentifier: CZStatusCellIdentifier.ForwardCell.rawValue)
        
        // 设置预估行高
//        tableView.estimatedRowHeight = 300  // 使用预估行高，拖动视图的时候会有小小的卡顿效果
         // AutomaticDimension 根据约束自己来设置高度
//        tableView.rowHeight = UITableViewAutomaticDimension
        // 消除分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
        // 获取模型
        let status = statuses![indexPath.row]
        // 获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(status.cellID()) as! CZStatusCell
        // 设置cell的模型
        cell.status = status
        
        // 当最后一个cell显示的时候来加载更多微博数据
        // 如果菊花正在显示,就表示正在加载数据,就不加载数据
        if indexPath.row == statuses!.count - 1 && !pullUpView.isAnimating() {
            // 上拉菊花开始转
            pullUpView.startAnimating()
            // 加载数据
            loadData()
        }
        
        return cell
    }
    // 使用 这个方法,会再次调用 heightForRowAtIndexPath,造成死循环
    //        tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    // 返回cell的高度,如果每次都去计算行高,消耗性能,缓存行高,将行高缓存到模型里面
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 获取模型
        let status = statuses![indexPath.row]
        
        // 1. 先去模型里面看有没缓存行高
        if let rowHeight = status.rowHeight {
            // 能进来说明缓存中有行高，直接返回缓存的行高
            return rowHeight
        }
        // 2. 缓存中没有行高
        let id = status.cellID()
        let cell = tableView.dequeueReusableCellWithIdentifier(id) as! CZStatusCell
        // 取出cell中计算好的行高
        let rowHeight = cell.rowHeight(status)
        // 赋值给缓存
        status.rowHeight = rowHeight
        
        return rowHeight
        
    }
    
    // MARK: - 懒加载
    /// 上拉加载更多数据显示的菊花
    private lazy var pullUpView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicator.color = UIColor.magentaColor()
        return indicator
    }()
    
    
}
