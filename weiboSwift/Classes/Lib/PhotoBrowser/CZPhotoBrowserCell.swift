//
//  CZPhotoBrowserCell.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/8.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

let CZPhotoBrowserCellMinimumZoomScale: CGFloat = 0.5

class CZPhotoBrowserCell: UICollectionViewCell {
    // MARK: - 属性
    /// 代理
    weak var cellDelegate: CZPhotoBrowserCellDelegate?
    /// 要显示图片的url地址
    var photoModel: CZPhotoBrowserModel? {
        didSet {
             // 下载图片
            guard let imageUrl = photoModel?.url else {
                print("imageURL 为空")
                return
            }
            // 将imageView图片设置为nil,防止cell重用
            imageView.image = nil
            // 清除属性
            resetProperties()
            
            // 显示下载指示器
            indicatorView.startAnimating()
            // 使用sd去下载
            imageView.sd_setImageWithURL(imageUrl) { (image, error, _, _) -> Void in
                 // 关闭下载指示器
                self.indicatorView.stopAnimating()
                if error != nil {
                    print("下载大图片出错:error: \(error), url:\(imageUrl)")
                    return
                }
                // 下载成功, 设置imageView的大小
//                 print("下载成功")
                self.layoutImageView(image)
            }
        }
    }
    
     /// 清除属性,防止cell复用
    private func resetProperties() {
        imageView.transform = CGAffineTransformIdentity
        
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSizeZero
    }
    
    /*
    等比例缩放到宽度等于屏幕的宽度后:
    1.高度大于等于屏幕的高度 -> 长图
    2.高度小于屏幕的高度 -> 短图
    */
    
    /// 根据长短图,重新布局imageView
    private func layoutImageView(image: UIImage) {
        // 获取等比例缩放后的图片大小
        let size = image.displaySize()
        // 判断长短图
        if size.height < UIScreen.height() {
            // 短图, 居中显示
//            imageView.bounds.size = size
//            imageView.center = contentView.center
            
            let offsetY = (UIScreen.height() - size.height) * 0.5
            // 不能通过frame来确定Y值,否则在放大的时候底部可会有看不到
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
             // 设置scrollView.contentInset.top是可以滚动的
            scrollView.contentInset = UIEdgeInsets(top: offsetY, left: 0, bottom: offsetY, right: 0)
        } else {
             // 长图, 顶部显示
            imageView.frame = CGRect(origin: CGPointZero, size: size)
            // 设置滚动
            scrollView.contentSize = size
        }
    }
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    // MARK: -  准备UI
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(scrollView)
        // 提示
        scrollView.addSubview(imageView)
        contentView.addSubview(indicatorView)
        
        // 设置scrollView的缩放
        scrollView.maximumZoomScale = 2
        scrollView.minimumZoomScale = CZPhotoBrowserCellMinimumZoomScale
        scrollView.delegate = self
        // 设置约束
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[sv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sv": scrollView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[sv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sv": scrollView]))
        
        // imageView的大小不固定.等获取到图片来计算
        
        // 进度指示器,居中显示
        contentView.addConstraint(NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
    }
    
    // MARK: - 懒加载
    /// scrollView
    private lazy var scrollView: UIScrollView = UIScrollView()
    /// imageView
    lazy var imageView: CZImageView = CZImageView()
    /// 下载图片提示
    private lazy var indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
}

// MARK: - 自定义代理CZPhotoBrowserCellDelegate协议
protocol CZPhotoBrowserCellDelegate: NSObjectProtocol {
    // 获取一个view,在缩放的时候修改alpha
    func viewForTransparent() -> UIView
    // 通知控制器关闭
    func cellDismiss()
}


extension CZPhotoBrowserCell: UIScrollViewDelegate {
    /// 返回需要缩放的view
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    /*
    print("imageView.frame:\(imageView.frame)")
    print("imageView.bounds:\(imageView.bounds)")
    缩放后frame会改变.bounds不会改变
    */
    /// scrollView缩放完毕调用
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        print("缩放完毕:\(imageView.transform)")
        // Y偏移
        var offsetY = (scrollView.bounds.height - imageView.frame.height) * 0.5
        // X偏移
        var offsetX = (scrollView.bounds.width - imageView.frame.width) * 0.5
        
        // 当 offset < 0 时,让 offset = 0,否则会拖不动, 因为scrollView的能否滚动是由contentSize的大小和scrollView的大小决定的，当scrollView的大小小于contentSize时才能滚动，下面设置了 scrollView.contentInset所以
        offsetY = offsetY < 0 ? 0 : offsetY
        offsetX = offsetX < 0 ? 0 : offsetX
        
        // 当缩放比例小于一定的值,就自动缩放回去
        if imageView.transform.a < 0.7 {
            // 关闭控制器
            //            cellDelegate?.cellDismiss()
            
            // 缩放到缩略图的位置,在关闭控制器
            // 获取缩略图
            let thumbImageView = photoModel!.imageView!
             // 计算缩放后的位置
            let frame = thumbImageView.superview!.convertRect(thumbImageView.frame, toCoordinateSpace: self)
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                // 设置 imageView的bounds
                self.imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
                
                self.scrollView.contentOffset.x = -frame.origin.x
                self.scrollView.contentOffset.y = -frame.origin.y
                
                self.scrollView.contentInset = UIEdgeInsets(top: frame.origin.y, left: frame.origin.x, bottom: 0, right: 0)

                }, completion: { (_) -> Void in
                    print("缩放完成,关闭控制器")
                    self.cellDelegate?.cellDismiss()
            })
            
            
        } else {
            UIView.animateWithDuration(0.25) { () -> Void in
                // 当缩放比例小于设置的最小缩放比例时,会动画到左上角,在调用 scrollViewDidEndZooming,不让系统缩放到比指定最小缩放比例还小的值
                // 设置scrollView的contentInset来居中图片
                scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
            }
        }
        
        
    }
     /// scrollView缩放时调用
    func scrollViewDidZoom(scrollView: UIScrollView) {
//        print("正在缩放")
        // 修改控制器的背景
        // 通过代理获取需要设置alpha的view
        let view = cellDelegate?.viewForTransparent()

        // 根据缩放比例来设置view的alpha
        if imageView.transform.a < 1 {
            // 设置alpah
            view?.alpha = imageView.transform.a * 0.7 - 0.2

        } else {
            view?.alpha = 1
        }

    }
}

