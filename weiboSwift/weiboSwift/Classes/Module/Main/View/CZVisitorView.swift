//
//  CZVisitorView.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/26.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

// 设置代理协议
protocol CZVisitorViewDelegate: NSObjectProtocol{
    
    func visitorViewRegisterBtnClick()
    func visitorViewLoginBtnClick()
    
}

class CZVisitorView: UIView {
    
    // 设置代理属性,是可选的，因为代理方法可实现也可不实现
    weak var visitorViewDelegate: CZVisitorViewDelegate?
    // MARK: - 按钮点击事件
    /// 注册
    func registBtnClick() {
        visitorViewDelegate?.visitorViewRegisterBtnClick()
    }
    
    /// 登陆
    func loginBtnClick(){
        visitorViewDelegate?.visitorViewLoginBtnClick()
    }
    
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    func setupVisitorView(imageName:String,message:String){
        // 隐藏房子
        homeView.hidden = true
        // 设置图像
        iconView.image = UIImage(named: imageName)
        // 设置显示信息
        msgLabel.text = message
        
        // 隐藏遮盖
        coverView.hidden = true
//        self.sendSubviewToBack(coverView) //这种方式也可以
        
    }
    
    // 转轮动画
    func startIconViewAnimitation(){
        let animation = CABasicAnimation()
        
        // 设置参数
        animation.keyPath = "transform.rotation"
        animation.toValue = M_PI * 2
        animation.repeatCount = MAXFLOAT
        animation.duration = 20
        // 完成的时候不移除
        animation.removedOnCompletion = false
        
        // 开始动画
        iconView.layer.addAnimation(animation, forKey: "homeRotation")
    }
    
    /// 暂停旋转
    func pauseAnimation() {
        // 记录暂停时间
        let pauseTime = iconView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        
        // 设置动画速度为0
        iconView.layer.speed = 0
        
        // 设置动画偏移时间
        iconView.layer.timeOffset = pauseTime
    }
    
    /// 恢复旋转
    func resumeAnimation() {
        // 获取暂停时间
        let pauseTime = iconView.layer.timeOffset
        
        // 设置动画速度为1
        iconView.layer.speed = 1
        
        iconView.layer.timeOffset = 0
        
        iconView.layer.beginTime = 0
        
        let timeSincePause = iconView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pauseTime
        
        iconView.layer.beginTime = timeSincePause
    }

    
    // 准备UI
    func prepareUI(){
        
        // 0. 设置背景
        self.backgroundColor = UIColor(white: 237/255.0, alpha: 1)
        
        // 1. 添加子控件
        addSubview(iconView)
        addSubview(coverView)  //遮盖
        addSubview(homeView)
        addSubview(msgLabel)
        addSubview(registerBtn)
        addSubview(loginBtn)
        
        // 2. 设置约束
        // 2.1 消除autoresizing
        iconView.translatesAutoresizingMaskIntoConstraints = false
        coverView.translatesAutoresizingMaskIntoConstraints = false
        homeView.translatesAutoresizingMaskIntoConstraints = false
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        registerBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // 2.2 添加约束
        // 2.2.1 转轮
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -40))
        // 2.2.2 小房子
        addConstraint(NSLayoutConstraint(item: homeView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: homeView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
        // 2.2.3 消息文字
        addConstraint(NSLayoutConstraint(item: msgLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: msgLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        
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
        
        // 2.2.6 遮盖
        addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: registerBtn, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
    }
    
    
    
    // MARK: - 懒加载
    
    // 1. 转轮
    private lazy var iconView:UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(named: "visitordiscover_feed_image_smallicon")
        // 自动匹配大小
        iconView.sizeToFit()
//        self.addSubview(iconView) 在里面添加没有效果
        return iconView
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
        btn.addTarget(self, action: "registBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    // 5. 登陆按钮
    private lazy var loginBtn:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitle("登陆", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        btn.sizeToFit()
        btn.addTarget(self, action: "loginBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    // 6. 遮盖
    private lazy var coverView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
}
