//
//  CZNewFeatureViewController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/30.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CZNewFeatureViewController: UICollectionViewController {

    // MARK: - 属性
    private let itemCount = 4
    
    /// layout
    private let layout = UICollectionViewFlowLayout()
    
    init() {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 此处注意注册类型是：CZNewFeatureCell,要不后面强转会出现问题
        self.collectionView!.registerClass(CZNewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        prepareLayout()
    }
    
    // MARK: - 设置layout的参数
    private func prepareLayout() {
        // 设置item的大小
        layout.itemSize = UIScreen.mainScreen().bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 设置滚动方向，默认是水平
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 分页
        collectionView?.pagingEnabled = true
        // 取出弹簧效果
        collectionView?.bounces = false
    }


    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return itemCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CZNewFeatureCell
        
        // Configure the cell
        cell.imageIndex = indexPath.item
        
        
        return cell
    }

    // collectionView显示完毕cell
    // collectionView分页滚动完毕cell看不到的时候调用
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // 正在显示的cell的indexPath
        let showIndexPath = collectionView.indexPathsForVisibleItems().first!
        // 获取collectionView正在显示的cell
        let cell = collectionView.cellForItemAtIndexPath(showIndexPath) as! CZNewFeatureCell
        
        if cell.imageIndex == itemCount - 1 {
            // 开始按钮动画
            cell.startButtonAnimation()
        }
    }

}

// MARK: - 自定义cell类
class CZNewFeatureCell: UICollectionViewCell {
    // MARK: 属性
    // 监听属性值的改变, cell 即将显示的时候会调用
    var imageIndex: Int = 0 {
        didSet{
            // 知道当前是哪一页
            // 设置图片
            backgroundImageView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            startButton.hidden = true  // 防止来回滚动造成按钮重用
        }
    }
    // MARK: - 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 开始按钮动画
    private func startButtonAnimation() {
        startButton.hidden = false
         // 把按钮的 transform 缩放设置为0
        startButton.transform = CGAffineTransformMakeScale(0, 0)
        
        // usingSpringWithDamping: 值越小弹簧效果越明显 0 - 1
        // initialSpringVelocity: 初速度
        UIView.animateWithDuration(1.0, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            self.startButton.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                
        }
    }
    
    // MARK: - 准备子控件
    private func prepareUI() {
         // 添加子控件
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(startButton)
        
        // 消除Autoresizing
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加约束
        // VFL
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : backgroundImageView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : backgroundImageView]))
         // 开始体验按钮
        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -160))
    }
    
    // 点击事件,如果声明成private,必须加@objc前缀,否则系统发现不了
    @objc private func startButtonClick() {
        // 切换到首页
        (UIApplication.sharedApplication().delegate as! AppDelegate).switchRootController(true)
    }
    
    // MARK: - 懒加载
    // 背景图片
    private lazy var backgroundImageView = UIImageView()
    // 开始体验按钮
    private lazy var startButton: UIButton = {
       let btn = UIButton()
         // 设置按钮背景
        btn.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        
        // 设置文字
        btn.setTitle("开始体验", forState: UIControlState.Normal)
        
        // 添加点击事件
        btn.addTarget(self, action: "startButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
    
    
}
