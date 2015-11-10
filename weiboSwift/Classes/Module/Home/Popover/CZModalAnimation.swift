//
//  CZModalAnimation.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/9.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZModalAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    // 返回 动画 时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    // 实现动画
    /*
    当实现这个方法,model出来的控制器的view是需要我们自己添加到容器视图
    
    transitionContext:
    转场的上下文.提供转场相关的元素
    
    containerView():
    容器视图
    
    completeTransition:
    当转场完成一定要调用,否则系统会认为转场没有完成,不能继续交互
    
    viewControllerForKey(key: String):
    拿到对应的控制器:
    modal时:
    UITransitionContextFromViewControllerKey: 调用presentViewController的对象
    UITransitionContextToViewControllerKey:
    modal出来的控制器
    
    viewForKey
    拿到对应的控制器的view
    UITransitionContextFromViewKey
    UITransitionContextToViewKey
    */

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
         // 将modal出来的控制器的view添加到容器视图
        let toview = transitionContext.viewForKey(UITransitionContextToViewKey)!
         // 设置缩放
        toview.transform = CGAffineTransformMakeScale(1, 0)
        // 设置缩放的锚点
        toview.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        // 添加到容器视图
        transitionContext.containerView()?.addSubview(toview)
        // 动画,弹簧效果
        UIView.animateWithDuration(transitionDuration(nil), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            toview.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                // 转成完成
                transitionContext.completeTransition(true)
        }
    }

}
