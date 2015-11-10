//
//  CZPopoverViewController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/9.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZPopoverViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    // MARK: - 属性
    private var content: [String] = ["首页", "好友圈", "群微博", "我的微博", "新浪微博"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("popoverCell")!
        cell.textLabel?.text = content[indexPath.row]
        return cell
    }
    
    
}
