//
//  CZStatusCell.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/31.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
let StatusCellMargin: CGFloat = 8
class CZStatusCell: UITableViewCell {
    // MARK: - 属性
    /// 配图宽度约束
    var pictureViewWidthCons: NSLayoutConstraint?
    /// 配图高度约束
    var pictureViewHeightCons: NSLayoutConstraint?
    
    /// 微博模型
    var status: CZStatus? {
        didSet{
            // 将模型赋值给 topView
            topView.status = status
            // 将模型赋值给配图视图
            pictureView.status = status
            // 重新设置配图的宽高约束
            pictureViewWidthCons?.constant = pictureView.calcPictureViewSize().width
            pictureViewHeightCons?.constant = pictureView.calcPictureViewSize().height
            // 设置微博内容
            contentLabel.text = status?.text
            
        }
    }
    
    // 设置cell的模型,cell会根据模型,从新设置内容,更新约束.获取子控件的最大Y值
    // 返回cell的高度
    func rowHeight(status: CZStatus) -> CGFloat {
        self.status = status
        // 重新布局
        layoutIfNeeded()
        
        // 获取子控件的最大Y值
        let maxY: CGFloat = CGRectGetMaxY(bottomView.frame)
        
        return maxY
        
    }
    
    
     // MARK: - 构造函数
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = UIColor.redColor()
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    func prepareUI() {
        // 添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        // 设置约束
        // 1. topView
        topView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSizeMake(UIScreen.width(), 54))
        // 2 .微博内容
        contentLabel.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPointMake(StatusCellMargin, StatusCellMargin))
        // 设置宽度
//        contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -StatusCellMargin*2))
        // 不能使用上面的约束方法,来约束contentLabel得宽度，会导致部分cell的高度改变，底部留下空白，原因不明
          contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: UIScreen.width() - 2 * StatusCellMargin))
        
        // 微博配图
        // 因为转发微博需要设置配图约束,不能再这里设置配图的约束,需要在创建一个cell继承CZStatusCell,添加上配图的约束
//        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size:
//            CGSizeZero, offset: CGPointMake(0, StatusCellMargin))
//        // 获取配图的宽高约束
//        pictureViewWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
//        pictureViewHeightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
        // 3. bottomView
        bottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: pictureView, size: CGSizeMake(UIScreen.width(), 44), offset: CGPointMake(-StatusCellMargin, StatusCellMargin))
        
        // 3. 添加contentView底部和bottomView的底部重合
//        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: bottomView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: StatusCellMargin))
        
    }
    
    // MARK: - 懒加载
    /// 顶部视图
    private lazy var topView:CZStatusTopView = CZStatusTopView()
    /// 微博内容
    lazy var contentLabel:UILabel = {
        let label = UILabel(fontSize: 16, textColor: UIColor.blackColor())
        
        // 设置显示多行
        label.numberOfLines = 0
        
        return label
    }()
    
    /// 微博配图
    lazy var pictureView: CZStatusPictureView = CZStatusPictureView()
    
    /// 底部视图
    lazy var bottomView: CZStatusBottomView = CZStatusBottomView()
    
}
