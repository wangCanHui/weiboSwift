//
//  CZRefreshController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/3.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZRefreshControl: UIRefreshControl {

    // MARK: - 属性
    // 箭头旋转的值
    private let refreshControlOffsetY:CGFloat = -60
     // 标记箭头的方向, 用于除去重复应答
    private var isUp = true
    
    /// 覆盖父类的frame属性
    override var frame: CGRect {
        didSet {
            if frame.origin.y > 0 {
                return
            }
            // 判断系统的刷新控件是否正在刷新
            if refreshing {
                 // 调用自定义的view,开始旋转
                refreshView.startLoading()
            }
            
            // 旋转箭头
            // 向上
            if frame.origin.y < refreshControlOffsetY && isUp {
                refreshView.rotationArrowIcon(isUp)
                isUp = false
            } else if frame.origin.y > refreshControlOffsetY && !isUp { //向下
                refreshView.rotationArrowIcon(isUp)
                isUp = true
            }
        }
    }
    // 重写 endRefreshing
    override func endRefreshing() {
        super.endRefreshing()
         // 停止旋转
        refreshView.stopLoading()
    }
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init() {
        super.init()
        
        prepareUI()
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        addSubview(refreshView)
        // 设置约束
        refreshView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: refreshView.bounds.size)
    }
    
    
    // MARK: - 懒加载
    /// 自定的刷新view, 从xib里面加载出来view的fram就有了
    private lazy var refreshView: CZRefreshView = CZRefreshView.refreshView()

}
// 自定义刷新的view
class CZRefreshView: UIView {
    // MARK: - 属性
    /// 菊花
    @IBOutlet weak var loadingView: UIImageView!
    /// 没有加载时，显示的提示
    @IBOutlet weak var tipView: UIView!
    /// 箭头图标
    @IBOutlet weak var arrowIcon: UIImageView!
    
    // MARK: - 加载xib
    class func refreshView() -> CZRefreshView{
//        let nibName = self as! String
//        print("nibName\(nibName)")
        return NSBundle.mainBundle().loadNibNamed("CZRefreshView", owner: nil, options: nil).last as! CZRefreshView
    }
    
    
    /**
    箭头旋转动画
    - parameter isUp: true,表示朝上, false,朝下
    */
    func rotationArrowIcon(isUp: Bool) {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.arrowIcon.transform = isUp ? CGAffineTransformMakeRotation(CGFloat(M_PI - 0.01)) : CGAffineTransformIdentity
        }
    }
    
    /// 开始旋转
    func startLoading() {
        // 如果动画正在执行,不添加动画
        let animkey = "animkey"
        // 获取图层上所有正在执行的动画的key
        if let _ = loadingView.layer.animationForKey(animkey) {
            // 找到对应的动画,动画正在执行,直接返回
            return
        }
        // 隐藏tipView，显示loadingView
        tipView.hidden = true
        // 旋转动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = M_PI * 2
        animation.duration = 0.5
        animation.repeatCount = MAXFLOAT
        animation.removedOnCompletion = false
        // 开始动画,如果名称一样,会先停掉正在执行的,在重新添加
        loadingView.layer.addAnimation(animation, forKey: animkey)
    }
    /// 停止旋转
    func stopLoading() {
        tipView.hidden = false
        // 移除动画
        loadingView.layer.removeAllAnimations()
    }
    
}