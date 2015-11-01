//
//  CZWelcomeViewController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/30.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
import SDWebImage

class CZWelcomeViewController: UIViewController {

    // MARK: - 属性
    /// 头像底部约束
    private var iconViewBottomCons: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        
        // 设置用户使用头像
        if let userIconViewName = CZUserAccount.loadAccount()?.avatar_large {   // 采用可选的处理方式。保证有值
            
            iconView.sd_setImageWithURL(NSURL(string: userIconViewName), placeholderImage: UIImage(named: "ad_background"))
        }
    }
    
    // MARK: - 设置动画效果
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 开始动画
        iconViewBottomCons?.constant = -(UIScreen.mainScreen().bounds.height - 160) // 表示距离view的最上方160，因为此约束是相对于view的底部
        
        // usingSpringWithDamping: 值越小弹簧效果越明显 0 - 1
        // initialSpringVelocity: 初速度
        UIView.animateWithDuration(1.0, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            // 重新布局产生动画效果，不要把执行动画效果的代码放到这里执行
            self.view.layoutIfNeeded()
            
            }) { (_) -> Void in
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    self.welcomeLabel.alpha = 1.0
                    }, completion: { (_) -> Void in
                        // 切换到首页
                        (UIApplication.sharedApplication().delegate as! AppDelegate).switchRootController(true)
                })
        }
        
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        view.addSubview(backgroundImageView)
        view.addSubview(iconView)
        view.addSubview(welcomeLabel)
        
        // 取消Autoresizing约束
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加约束
        
        // 1. 背景
        // 填充父控件 VFL
        /*
        H | 父控件的左边 | 父控件的右边
        V | 父控件的顶部 | 父控件的底部
        */
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg": backgroundImageView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : backgroundImageView]))
        
        // 2. 头像
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 85))
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 85))
        // 垂直 底部160
        iconViewBottomCons = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -160)
        view.addConstraint(iconViewBottomCons!)
        
        // 3. 欢迎归来
        view.addConstraint(NSLayoutConstraint(item: welcomeLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: welcomeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
    }
    
    // MARK: - 懒加载
    // 背景图片
    private lazy var backgroundImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    // 头像
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView(image: UIImage(named: "avatar_default_big"))
        // 切成圆
        iconView.layer.cornerRadius = 42.5
        iconView.layer.masksToBounds = true

        return iconView
    }()
  
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "欢迎归来"
        label.alpha = 0.0
        
       return label
    }()
}
