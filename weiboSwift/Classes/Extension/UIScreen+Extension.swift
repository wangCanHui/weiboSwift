

//
//  UIScreen+Extension.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/1.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

/// 扩展UIScreen
extension UIScreen {
    
     // 提供直接返回屏幕宽度
    class func width() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    // 提供直接返回屏幕高度
    class func height() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
}
