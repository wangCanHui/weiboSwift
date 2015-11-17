//
//  CZImageView.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/11.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZImageView: UIImageView {

   // 覆盖父类的属性
    override var transform: CGAffineTransform {
        didSet {
             // 当设置的缩放比例小于指定的最小缩放比例时.重新设置
            if transform.a < CZPhotoBrowserCellMinimumZoomScale {
//                 print("设置 transform.a:\(transform.a)")
                transform = CGAffineTransformMakeScale(CZPhotoBrowserCellMinimumZoomScale,CZPhotoBrowserCellMinimumZoomScale)
            }
        }
    }

}
