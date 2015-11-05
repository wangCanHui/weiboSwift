//
//  CZStatusForwardCell.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/2.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZStatusForwardCell: CZStatusCell {
    
    // 覆盖父类的模型属性
    // 添加 override关键字,实现属性监视器,先调用父类的属性监视器,在调用子类的属性监视器
    override var status: CZStatus? {
        didSet{
            let name = status?.retweeted_status?.user?.name ?? "无名"
            let text = status?.retweeted_status?.text ?? "无内容"
            forwardLabel.text = "@\(name):\(text)"
        }
    }
    
    /// 覆盖父类的方法
    override func prepareUI() {
        super.prepareUI()
        // 添加子控件
        contentView.insertSubview(bkgButton, belowSubview: pictureView)
        contentView.addSubview(forwardLabel)
        
        // 设置约束
        // 背景
        // 左上角约束
        bkgButton.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: nil ,offset: CGPointMake(-StatusCellMargin, StatusCellMargin))
        // 右下角
        bkgButton.ff_AlignVertical(type: ff_AlignType.TopRight, referView: bottomView, size: nil)
        
        // 被转发微博内容forwardLabel
        forwardLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: bkgButton, size: nil, offset: CGPointMake(StatusCellMargin, StatusCellMargin))
        // 宽度约束
        contentView.addConstraint(NSLayoutConstraint(item: forwardLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -StatusCellMargin*2))

        // 被转发微博的配图
        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: forwardLabel, size: CGSizeZero, offset: CGPointMake(0, StatusCellMargin))
        // 获取配图的宽高约束
        pictureViewWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureViewHeightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
    }
    
    
    // MARK: - 懒加载
    /// 灰色的背景
    private lazy var bkgButton: UIButton = {
       let btn = UIButton()
        // 设置背景色
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return btn
    }()
    
    /// 被转发微博内容label
    private lazy var forwardLabel: UILabel = {
        let label = UILabel(fontSize: 14, textColor: UIColor.darkGrayColor())
        label.text = "我是测试文字我是测试文字我是测试文字我是测试文字我是测试文字我是测试文字我是测试文字我是测试文字我是测试文字我是测试文字我是测试文字我是测试文字我是测试文字"
        
        label.numberOfLines = 0
        
        return label
    }()
}

