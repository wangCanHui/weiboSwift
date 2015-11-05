//
//  CZStatusBottomView.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/1.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZStatusBottomView: UIView {

    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = UIColor.whiteColor()
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    // MARK: - 准备UI
    private func prepareUI() {
        addSubview(forwardButton)
        addSubview(commentButton)
        addSubview(lickButton)
        addSubview(separatorViewOne)
        addSubview(separatorViewTwo)
        
        // 添加约束
        /// 3个按钮水平平铺父控件
        // 父控件调用
        // HorizontalTile: 水平平铺
        // views: 要平铺的子控件
        self.ff_HorizontalTile([forwardButton,commentButton,lickButton], insets: UIEdgeInsetsZero)
        
        // 分割线1
        separatorViewOne.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: forwardButton, size: nil)
        
        // 分割线2
        separatorViewTwo.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: commentButton, size: nil)
        
    }
    
    // MARK: - 懒加载
    /// 转发
    private lazy var forwardButton: UIButton = UIButton(imageName: "timeline_icon_retweet", title: "转发", titleColor: UIColor.lightGrayColor(), fontSize: 12)
    /// 评论
    private lazy var commentButton: UIButton = UIButton(imageName: "timeline_icon_comment", title: "评论", titleColor: UIColor.lightGrayColor(), fontSize: 12)
    ///  赞
    private lazy var lickButton: UIButton = UIButton(imageName: "timeline_icon_unlike", title: "赞", titleColor: UIColor.lightGrayColor(), fontSize: 12)
    /// 水平分割线 1
    private lazy var separatorViewOne: UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    
    /// 水平分割线2
    private lazy var separatorViewTwo: UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    
}
