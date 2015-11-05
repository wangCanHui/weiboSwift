
//
//  UILabel+Extension.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/31.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

/// 扩展UILabel
extension UILabel {
    
    convenience init (fontSize: CGFloat,textColor: UIColor) {
        // 调用本类的指定构造函数
        self.init()
        // 设置文字颜色
        self.textColor = textColor
        // 设置字体大小
        font = UIFont.systemFontOfSize(fontSize)
        
    }
}
