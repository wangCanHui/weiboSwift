//
//  File.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/8.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
// 扩展 UIImage
extension UIImage {
    
    /**
    等比例缩小, 缩小到宽度等于300
    - returns: 缩小的图片
    */
    func scaleImage() -> UIImage {
        let newWidth: CGFloat = 300
        // 图片宽度本来就小于300
        if size.width < 300 {
            return self
        }
        // 等比例缩放
        // newHeight / newWidth = 原来的高度 / 原来的宽度
        let newHeight = size.height * newWidth / size.width
        let newSize = CGSize(width: newWidth, height: newHeight)
        
         // 准备图片的上下文
        UIGraphicsBeginImageContext(newSize)
         // 将当前图片绘制到rect上面
//        drawAsPatternInRect()
        drawInRect(CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        // 从上下文获取绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭图片上下文
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
