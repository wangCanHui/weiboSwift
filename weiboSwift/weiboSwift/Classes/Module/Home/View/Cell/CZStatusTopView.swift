
//
//  CZStatusTopView.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/31.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZStatusTopView: UIView {

    // MARK: - 微博模型
    var status: CZStatus? {
        didSet{ // 相当于OC中的setter方法，用于对属性赋值
            // 设置视图内容
            // 用户头像
            if let iconUrl = status?.user?.profile_image_url {
               iconView.sd_setImageWithURL(NSURL(string: iconUrl))
            }
            // 认证类型
            // 判断类型设置不同的图片
            // 没有认证:-1   认证用户:0  企业认证:2,3,5  达人:220
            verifiedView.image = status?.user?.verifiedTypeImage
            
            // 名称
            nameLabel.text = status?.user?.name
            
            // 时间
            timeLabel.text = status?.created_at
            
            // 来源
            sourceLabel.text = "来自 ** 微博"
            
            // 会员
            memberView.image = status?.user?.mbrankImage
            
        }
    }
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = UIColor.greenColor()
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(memberView)
        
        // 添加约束
        /// 头像视图
        iconView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: CGSizeMake(35, 35), offset: CGPointMake(8, 8))
        /// 认证图标
        verifiedView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: iconView, size: CGSizeMake(17, 17), offset: CGPointMake(8.5, 8.5))
        /// 名称
        nameLabel.ff_AlignHorizontal(type: ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPointMake(8, 0))
        /// 时间
        timeLabel.ff_AlignHorizontal(type: ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPointMake(8, 0))
        /// 来源
        sourceLabel.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: timeLabel, size: nil, offset: CGPointMake(8, 0))
        /// 会员等级
        memberView.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: nameLabel, size: CGSizeMake(14, 14), offset: CGPointMake(8, 0))
        
    }
    
    // MARK: - 懒加载
    /// 用户头像
    private lazy var iconView = UIImageView()
    
    /// 认证图标
    private lazy var verifiedView = UIImageView()
    
    /// 用户名称
    private lazy var nameLabel = UILabel(fontSize: 14, textColor: UIColor.darkGrayColor())
    
     /// 时间label
    private lazy var timeLabel = UILabel(fontSize: 9, textColor: UIColor.orangeColor())
    
    /// 来源label
    private lazy var sourceLabel = UILabel(fontSize: 9, textColor: UIColor.lightGrayColor())
    
    /// 会员等级
    private lazy var memberView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
}
