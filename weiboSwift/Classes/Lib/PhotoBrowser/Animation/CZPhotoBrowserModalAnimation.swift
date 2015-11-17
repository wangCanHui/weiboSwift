//
//  CZPhotoBrowserModalAnimation.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/11.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZPhotoBrowserModalAnimation: NSObject , UIViewControllerAnimatedTransitioning {
    // 返回动画的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // 自定义动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 获取modal出来的控制器的view
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        toView.alpha = 0
        // 添加到容器视图
        transitionContext.containerView()?.addSubview(toView)
        // 获取Modal出来的控制器
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! CZPhotoBrowserViewController
        // 获取过渡的视图
        let tempImageView = toVC.modalTempImageView()
        // TODO: 测试,添加到window上面
        //        UIApplication.sharedApplication().keyWindow?.addSubview(tempImageView)
        transitionContext.containerView()?.addSubview(tempImageView)
        // 隐藏collectionView
        toVC.collectionView.hidden = true
        // 动画
        UIView.animateWithDuration(transitionDuration(nil), animations: { () -> Void in
            // 设置透明
            toView.alpha = 1.0
            // 设置过渡视图最终动画放大完成的frame
            tempImageView.frame = toVC.modalTargetFrame()
            
            }) { (_) -> Void in
                // 移除过渡视图
                tempImageView.removeFromSuperview()
                // 显示collectioView
                toVC.collectionView.hidden = false
                 // 转场完成
                transitionContext.completeTransition(true)
        }
        
    }
}
