
//
//  UIColor+Extension.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/31.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

// 扩展UIColor的功能

extension UIColor {
    
    /// 返回一个随机色
    class func randomColor() -> UIColor {
       return UIColor(red: randomValue(), green: randomValue(), blue: randomValue(), alpha: 1)
    }
    
    /// 随机 0 - 255 的值
    private class func randomValue() -> CGFloat {
    
        return CGFloat(arc4random_uniform(256)) / 255

    }
    
}
