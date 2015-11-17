//
//  CZPhotoBrowserViewController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/8.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
// 页间距
let CZPhotoBrowserMinimumLineSpacing: CGFloat = 10

class CZPhotoBrowserViewController: UIViewController {
    // MARK: - 属性
    /// cell重用id
    private let reuseIdentifier = "Cell"
    /// 大图的urls
//    private var urls: [NSURL]
    private var photoModels: [CZPhotoBrowserModel]
    /// 当前页索引
    private var selectedIndex: Int
    /// 流水布局
    private let layout = UICollectionViewFlowLayout()
    
     // MARK: - 构造函数
    init(photoModels:[CZPhotoBrowserModel],selectedIndex:Int) {
        self.photoModels = photoModels
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     // 显示点击对应的大图
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 滚动到对应的张数 selectedIndex-> IndexPath
        let indexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
        // 滚动到对应的张数
//        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.Left)
//        print("--\(collectionView.frame)")   // 注意如果collectionView使用约束布局的话，在viewWillAppear方法里面还没有生效，此时上面的滚动是没有效果的
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 背景色
        view.backgroundColor = UIColor.clearColor()
        prepareUI()
         // 设置页数  当前页 / 总页数
        pageLabel.text = "\(selectedIndex + 1) / \(photoModels.count)"
    }
    
    // MARK: - 按钮点击事件
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func save() {
//        print("参数:urls:\(urls), index:\(selectedIndex)")
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 给按钮添加点击事件
        closeButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        
        // 添加子控件
        // 注意背景视图添加在最底部
        view.addSubview(bkgView)
        view.addSubview(collectionView)
        view.addSubview(pageLabel)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        // 设置约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 设置 背景视图的frame
        bkgView.frame = view.bounds
        
        let views = [
            "cv": collectionView,
            "pl": pageLabel,
            "cb": closeButton,
            "sb": saveButton
        ]
        // collectionView, 填充父控件
        // collectionView, 填充父控件
        // 将colllectionView的宽度+间距
        collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.width() + CZPhotoBrowserMinimumLineSpacing, height: UIScreen.height())
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        // 页码
        view.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20))
        // 关闭、保存按钮
        // 高度35距离父控件底部8
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cb(35)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[sb(35)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        // 宽度75,距离父控件边距8
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[cb(75)]-(>=0)-[sb(75)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        // 设置collectionView
        prepareCollectionView()
    }
    
    // MARK: - 设置collectionView
    private func prepareCollectionView() {
        // 注册cell
        collectionView.registerClass(CZPhotoBrowserCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
         // 设置collelctionView的背景颜色
        collectionView.backgroundColor = UIColor.clearColor() // 默认是黑色的
        
         // layout.item
        layout.itemSize = view.bounds.size
        
        // 让最后一页也不显示页间距
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CZPhotoBrowserMinimumLineSpacing)
        
        // 滚动方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 间距设置为0
        layout.minimumInteritemSpacing = CZPhotoBrowserMinimumLineSpacing
        layout.minimumLineSpacing = CZPhotoBrowserMinimumLineSpacing
        // 不需要弹簧效果
        collectionView.bounces = false
         // 分页显示
        collectionView.pagingEnabled = true
        // 数据源和代理
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - 懒加载
    /// collectionView
    // 隐藏collectionView
    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
     /// 关闭按钮
    private lazy var closeButton: UIButton = UIButton(bkgImageName: "health_button_orange_line", title: "关闭", titleColor: UIColor.orangeColor(), fontSize: 12)
    /// 保存按钮
    private lazy var saveButton: UIButton = UIButton(bkgImageName: "health_button_orange_line", title: "保存", titleColor: UIColor.orangeColor(), fontSize: 12)
    /// 页码的label
    private lazy var pageLabel: UILabel = UILabel(fontSize: 15, textColor: UIColor.redColor())
    /// 背景视图,用于修改alpha
    private lazy var bkgView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()

}

// MARK: - 扩展 CZPhotoBrowserViewController 实现 UICollectionViewDataSource 和 UICollectionViewDelegate
extension CZPhotoBrowserViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    // 返回cell的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModels.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CZPhotoBrowserCell
        // Configure the cell
        cell.backgroundColor = UIColor.clearColor()
        cell.photoModel = photoModels[indexPath.item]
        // 设置代理
        cell.cellDelegate = self
        return cell
    }
    // scrolView停止滚动,获取当前显示cell的indexPath
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
         // 获取正在显示的cell
        let indexPath = collectionView.indexPathsForVisibleItems().first!
          // 赋值 selectedIndex,
        selectedIndex = indexPath.item
        // 设置页数  当前页 / 总页数
        pageLabel.text = "\(selectedIndex + 1) / \(photoModels.count)"

    }
}

// MARK: - 扩展 CZPhotoBrowserViewController 实现 CZPhotoBrowserCellDelegate 协议
extension CZPhotoBrowserViewController: CZPhotoBrowserCellDelegate {
    
    func viewForTransparent() -> UIView {
        return bkgView
    }
    // 关闭控制器
    func cellDismiss() {
        close()
    }
}


// MARK: - 扩展 CZPhotoBrowserViewController 实现 UIViewControllerTransitioningDelegate协议
extension CZPhotoBrowserViewController: UIViewControllerTransitioningDelegate {
     // 返回 控制 modal动画 对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // 创建 控制 modal动画 对象
        return CZPhotoBrowserModalAnimation()
    }
    // 控制 dismiss动画 对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CZPhotoBrowserDismissAnimation()
    }
}

// MARK: - 转场动画
extension CZPhotoBrowserViewController {
    // 提供转场动画的过渡视图, 需要知道显示的图片,还需要知道点击的cell的frame

    // MARK: - modal动画相关
    /**
    返回modal出来时需要的过渡视图
    - returns: modal出来时需要的过渡视图
    */
    func modalTempImageView() -> UIImageView {
        // 缩略图的view
        let thumbImageView = photoModels[selectedIndex].imageView!
        // 创建过渡视图
        let tempImageView = UIImageView(image: thumbImageView.image)
        // 设置参数
        tempImageView.contentMode = thumbImageView.contentMode
        tempImageView.clipsToBounds = true
        
        // 设置过渡视图的frame
        // 直接设置是不行的,坐标系不一样
        //        tempImageView.frame = thumbImageView.frame
        
        // thumbImageView.superview!: 转换前的坐标系
        // rect: 需要转换的frame
        // toCoordinateSpace: 转换后的坐标系
        let frame = thumbImageView.superview!.convertRect(thumbImageView.frame, toCoordinateSpace: view)
         // 设置转换好的frame
        tempImageView.frame = frame
        return tempImageView
    }
    /**
    返回 modal动画放大后的frame
    - returns: modal动画放大后的frame
    */
    func modalTargetFrame() -> CGRect {
        // 获取到对应的缩略图
        let thumbImageView = photoModels[selectedIndex].imageView!
        // 获取缩略图
        let thumbImage = thumbImageView.image!
        // 计算宽高
        let newSize = thumbImage.displaySize()
        // 判断长短图
        var offsetY: CGFloat = 0
        if newSize.height < UIScreen.height() {
            offsetY = (UIScreen.height() - newSize.height) * 0.5
        }
        return CGRect(x: 0, y: offsetY, width: newSize.width, height: newSize.height)
        
    }
    
    // MARK: - dismiss动画相关
    /**
    返回dismiss时的过渡视图
    - returns: dismiss时的过渡视图
    */
    func dismissTempImageView() -> UIImageView {
        // 获取正在显示的cell
        let indexPath = collectionView.indexPathsForVisibleItems().first!
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CZPhotoBrowserCell
         // 获取正在显示的图片
        let image = cell.imageView.image
         // 创建过渡视图
        let tempImageView = UIImageView(image: image)
        // 设置过渡视图
        tempImageView.contentMode = UIViewContentMode.ScaleAspectFill
        tempImageView.clipsToBounds = true
        // 设置frame
        // 转换坐标系
        let frame = cell.imageView.superview!.convertRect(cell.imageView.frame, toCoordinateSpace: view)
        tempImageView.frame = frame
        
        return tempImageView
    }
    
    /**
    返回缩小后的fram
    - returns: 缩小后的fram
    */
    func dismissTargetFrame() -> CGRect {
        // 缩略图的view
        let thumbImageView = photoModels[selectedIndex].imageView!
        return  thumbImageView.superview!.convertRect(thumbImageView.frame, toCoordinateSpace: view)
    }
}

