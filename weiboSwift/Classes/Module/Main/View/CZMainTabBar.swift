//
//  CZMainTabBar.swift
//  GZWeibo05
//
//  Created by zhangping on 15/10/26.
//  Copyright © 2015年 zhangping. All rights reserved.
//

import UIKit

class CZMainTabBar: UITabBar {
    
    private let count: CGFloat = 5
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 计算宽度
        let width = bounds.width / count
        
        // frame 
        let frame = CGRect(x: 0, y: 0, width: width, height: bounds.height)
        
        var index = 0
        for view in subviews {
            // 判断 UITabBarButton 才设置frame
            // is 判断是否是某个类型
            if view is UIControl && !(view is UIButton) {
                print("view: \(view)")
                view.frame = CGRectOffset(frame, width * CGFloat(index), 0)
                
//                index++
//                if index == 2 {
//                    index++
//                }
                index += index == 1 ? 2 : 1
            }
        }
        print("-------")
        
        // 设置撰写按钮frame
        composeButton.frame = CGRectOffset(frame, width * 2, 0)
    }
    
    // MARK: - 懒加载
    lazy var composeButton: UIButton = {
        let button = UIButton()
        
        // 按钮图片
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        // 按钮的背景
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        self.addSubview(button)
        
        return button
    }()
}
