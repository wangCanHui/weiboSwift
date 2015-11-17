//
//  CZProfileViewController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/26.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
import SDWebImage

class CZProfileViewController: CZBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         // 获取SDWebImage缓存图片的大小
        let size = Double(SDImageCache.sharedImageCache().getSize()) / 1000.0 / 1000.0
        let newSize = String(format: "%.2f", arguments: [size])
        navigationItem.title = "缓存大小:\(newSize) M"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "清理缓存", style: UIBarButtonItemStyle.Plain, target: self, action: "clear")
    }
    
    func clear() {
        SDImageCache.sharedImageCache().clearDiskOnCompletion { () -> Void in
//            print("清除缓存完成")
            // 刷新显示
            self.viewDidLoad()
        }
    }


}
