//
//  CZStatusNormalCell.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/2.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZStatusNormalCell: CZStatusCell {

    override func prepareUI() {
        // 调用父类的
        super.prepareUI()

        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPointMake(0, StatusCellMargin))
        // 给属性pictureViewWidthCons、pictureViewHeightCons赋初始值
        pictureViewWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureViewHeightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }

}
