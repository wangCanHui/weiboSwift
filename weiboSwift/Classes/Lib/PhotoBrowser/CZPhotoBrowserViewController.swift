//
//  CZPhotoBrowserViewController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/8.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZPhotoBrowserViewController: UIViewController {
    // MARK: - 属性
    /// cell重用id
    private let reuseIdentifier = "Cell"
    /// 大图的urls
    private var urls: [NSURL]
    /// 当前页索引
    private var selectedIndex: Int
    /// 流水布局
    private let layout = UICollectionViewFlowLayout()
    
     // MARK: - 构造函数
    init(urls:[NSURL],selectedIndex:Int) {
        self.urls = urls
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
         // 设置页数  当前页 / 总页数
        pageLabel.text = "\(selectedIndex + 1) / \(urls.count)"
    }
    
    // MARK: - 按钮点击事件
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func save() {
        print("参数:urls:\(urls), index:\(selectedIndex)")
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 给按钮添加点击事件
        closeButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(pageLabel)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        // 设置约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [
            "cv": collectionView,
            "pl": pageLabel,
            "cb": closeButton,
            "sb": saveButton
        ]
        // collectionView, 填充父控件
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
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
         // layout.item
        layout.itemSize = view.bounds.size
        // 滚动方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 间距设置为0
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
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
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
     /// 关闭按钮
    private lazy var closeButton: UIButton = UIButton(bkgImageName: "health_button_orange_line", title: "关闭", titleColor: UIColor.orangeColor(), fontSize: 12)
    /// 保存按钮
    private lazy var saveButton: UIButton = UIButton(bkgImageName: "health_button_orange_line", title: "保存", titleColor: UIColor.orangeColor(), fontSize: 12)
    /// 页码的label
    private lazy var pageLabel: UILabel = UILabel(fontSize: 15, textColor: UIColor.redColor())

}

// MARK: - 扩展 CZPhotoBrowserViewController 实现 UICollectionViewDataSource 和 UICollectionViewDelegate
extension CZPhotoBrowserViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    // 返回cell的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CZPhotoBrowserCell
        // Configure the cell
        cell.backgroundColor = UIColor.randomColor()
        cell.url = urls[indexPath.item]
        return cell
    }
    // scrolView停止滚动,获取当前显示cell的indexPath
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
         // 获取正在显示的cell
        let indexPath = collectionView.indexPathsForVisibleItems().first!
          // 赋值 selectedIndex,
        selectedIndex = indexPath.item
        // 设置页数  当前页 / 总页数
        pageLabel.text = "\(selectedIndex + 1) / \(urls.count)"

    }
}

