//
//  CZVisitorView.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/26.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZVisitorView: UIView {
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    // 准备UI
    func prepareUI(){
        // 1. 添加子控件
        addSubview(wheelView)
        addSubview(homeView)
        addSubview(msgLabel)
        addSubview(registerBtn)
        addSubview(loginBtn)
        
        // 2. 设置约束
        // 2.1 消除autoresizing
        wheelView.translatesAutoresizingMaskIntoConstraints = false
        homeView.translatesAutoresizingMaskIntoConstraints = false
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        registerBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // 2.2 添加约束
        // 2.2.1 转轮
        addConstraint(NSLayoutConstraint(item: wheelView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: wheelView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -40))
        // 2.2.2 小房子
        addConstraint(NSLayoutConstraint(item: homeView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: wheelView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: homeView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: wheelView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
        // 2.2.3 消息文字
        addConstraint(NSLayoutConstraint(item: msgLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: wheelView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: msgLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: wheelView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        
        // 2.2.4 注册按钮
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: msgLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: msgLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35))
        
        // 2.2.5 登陆按钮
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: msgLabel, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: msgLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35))
        
    }

    // MARK: - 懒加载
    
    // 1. 转轮
    private lazy var wheelView:UIImageView = {
        let wheelView = UIImageView()
        wheelView.image = UIImage(named: "visitordiscover_feed_image_smallicon")
        // 自动匹配大小
        wheelView.sizeToFit()
//        self.addSubview(wheelView) 在里面添加没有效果
        return wheelView
        }()
    
    // 2. 小房子，只有首页有
    private lazy var homeView:UIImageView = {
       let homeView = UIImageView()
        homeView.image = UIImage(named: "visitordiscover_feed_image_house")
        homeView.sizeToFit()
        return homeView
    }()
    
    // 3. 消息文字
    private lazy var msgLabel:UILabel = {
       let msg = UILabel()
        msg.text = "关注一些人,看看有什么惊喜"
        msg.numberOfLines = 0
        msg.preferredMaxLayoutWidth = 240
        msg.tintColor = UIColor.lightGrayColor()
        msg.sizeToFit()
        return msg
    }()
    
    // 4. 注册按钮
    private lazy var registerBtn:UIButton = {
       let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.sizeToFit()
        return btn
    }()
    
    // 5. 登陆按钮
    private lazy var loginBtn:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitle("登陆", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        btn.sizeToFit()
        return btn
    }()
}
