//
//  CZStatusCell.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/31.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZStatusCell: UITableViewCell {
    // MARK: - 属性
    /// 微博模型
    var status: CZStatus? {
        didSet{
            // 将模型赋值给 topView
            topView.status = status
            // 设置微博内容
            contentLabel.text = status?.text
        }
    }
     // MARK: - 构造函数
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        
        // 设置约束
        // 1. topView
        topView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 44))
        // 2 .微博内容
        contentLabel.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPointMake(8, 8))
        // 设置宽度
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -8*2))
        
        // 3. 添加contentView底部和contentLabel的底部重合
        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 8))
        
        
    }
    
    // MARK: - 懒加载
    /// 顶部视图
    private lazy var topView:CZStatusTopView = CZStatusTopView()
    /// 微博内容
    private lazy var contentLabel:UILabel = {
        let label = UILabel(fontSize: 16, textColor: UIColor.blackColor())
        
        // 设置显示多行
        label.numberOfLines = 0
        
        return label
    }()
    
    
}
