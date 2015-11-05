
//
//  UIBarButtonItem+Extension.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/31.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    // 扩展里面只能是便利构造函数
    convenience init(imageName: String) {
        
        let button = UIButton()
        // 设置背景图片
        button.setBackgroundImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
        
        button.sizeToFit() // 相当于设置Bounds
        
        self.init(customView: button)
    }
    
    /// 不创建对象就调用,生成一个带按钮的UIBarButtonItem
    class func navigationItem(imageName: String) -> UIBarButtonItem {
        
        let button = UIButton()
        // 设置背景图片
        button.setBackgroundImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
        
        button.sizeToFit() // 相当于设置Bounds

        return UIBarButtonItem(customView: button)
    }
}
