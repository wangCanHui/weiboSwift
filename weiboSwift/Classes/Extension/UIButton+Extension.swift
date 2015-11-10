
//
//  UIButton+Extension.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/1.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
/// 扩展UIButton
extension UIButton {
    
    /**
     快速创建按钮
     - parameter imageName:  图片名称
     - parameter title:      标题
     - parameter titleColor: 标题颜色
     - parameter fontSize:   标题大小
     - returns: 按钮
     */

    convenience init(imageName: String,title: String,titleColor: UIColor,fontSize: CGFloat) {
        self.init()
        
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setTitle(title, forState: UIControlState.Normal)
        setTitleColor(titleColor, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
   
    /**
     快速创建按钮
     - parameter bkgImageName:  背景图片名称
     - parameter title:      标题
     - parameter titleColor: 标题颜色
     - parameter fontSize:   标题大小
     - returns: 按钮
     */
    
    convenience init(bkgImageName: String,title: String,titleColor: UIColor,fontSize: CGFloat) {
        self.init()
        
        setBackgroundImage(UIImage(named: bkgImageName), forState: UIControlState.Normal)
        setTitle(title, forState: UIControlState.Normal)
        setTitleColor(titleColor, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
}
