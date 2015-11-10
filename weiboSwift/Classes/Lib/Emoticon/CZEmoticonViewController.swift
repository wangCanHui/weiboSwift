//
//  CZEmoticonViewController.swift
//  表情键盘
//
//  Created by 王灿辉 on 15/11/5.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZEmoticonViewController: UIViewController {

    // MARK: - 属性
    private let collectionViewCellIdentifier = "collectionViewCellIdentifier"
    /// 记录当前选中高亮的按钮
    private var selectedButton: UIButton?
    /// textView
    weak var textView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        view.backgroundColor = UIColor.redColor()
        prepareUI()
        
//        print("viewDidLoad view.frame:\(view.frame)")
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        print("viewWillAppear view.frame:\(view.frame)")
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        // viewDidAppear view.frame:(0.0, 0.0, 375.0, 216.0)
//        print("viewDidAppear view.frame:\(view.frame)")
//    }
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        // 设置约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["cv" : collectionView, "tb" : toolBar]
        // VFL
        // collectionView水平方向
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        // toolBar水平方向
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        // 垂直方向
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-[tb(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        setupToolBar()
        setupCollectionView()
    }
    
     /// 设置toolBar
    private func setupToolBar() {
        var items = [UIBarButtonItem]()
        // 记录 item 的位置
        var index = 0
        for packge in packages {
        let name = packge.group_name_cn
           let button = UIButton()
            // 设置标题
            button.setTitle(name, forState: UIControlState.Normal)
            // 设置颜色
            button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
            button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Selected)
            // 设置大小,不然不会显示
            button.sizeToFit()
            // 设置tag
            button.tag = index
            // 添加单击事件
            button.addTarget(self, action: "itemClick:", forControlEvents: UIControlEvents.TouchUpInside)
            // 让最近表情包默认选中高亮
            if index == 0 {
                switchSelectedButton(button)
            }
            // 创建 barbuttomitem
            let item = UIBarButtonItem(customView: button)
            items.append(item)
            // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
            index++ // index和++之间不能空格
        }
        // 移除最后一个多有的弹簧
        items.removeLast()
        toolBar.items = items
    }
    // 处理toolBar点击事件
    func itemClick(button: UIButton) {
         // scction 0 - 3
        let indexPath = NSIndexPath(forItem: 0, inSection: button.tag)
        // 让collectionView滚动到对应位置
        // indexPath: 要显示的cell的indexPath
        // animated: 是否动画
        // scrollPosition: 滚动位置
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        switchSelectedButton(button)
    }
    /**
     使按钮高亮
     - parameter button: 要高亮的按钮
     */
    private func switchSelectedButton(button: UIButton) {
        // 取消之前选中的
        selectedButton?.selected = false
        
        // 让点击的按钮选中
        button.selected = true
        
        // 将点击的按钮赋值给选中的按钮
        selectedButton = button
    }

    
    /// 设置collectioView
    private func setupCollectionView() {
        // 设置背景颜色
        collectionView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        // 设置数据
        collectionView.dataSource = self
        // 设置代理
        collectionView.delegate = self
        // 注册cell
        collectionView.registerClass(CZEmotionCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        
    }
    
    // MARK: - 懒加载
    /// collectionView
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: CZCollectionViewFlowLayout())
    /// toolBar
    private lazy var toolBar = UIToolbar()
    /// 表情包模型
    private lazy var packages = CZEmoticonPackage.packages
}

// MARK: - 扩展 CZEmoticonViewController 实现 协议 UICollectionViewDataSource
extension CZEmoticonViewController: UICollectionViewDataSource , UICollectionViewDelegate{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
         // 获取对应的表情模型
        let emoticon = packages[indexPath.section].emoticons?[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionViewCellIdentifier, forIndexPath: indexPath) as! CZEmotionCell
        cell.emoticon = emoticon
        return cell
    }
    
    // 监听scrollView滚动,当停下来的时候判断显示的是哪个section
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 获取到正在显示的section -> indexPath
        // 获取到collectionView正在显示的cell的IndexPath
        if let indexPath = collectionView.indexPathsForVisibleItems().first {
            
            let section = indexPath.section
            var buttonArr = [UIButton]()
            for item in toolBar.subviews {
                if item.isKindOfClass(UIButton) {
                    let button = item as! UIButton
                    buttonArr.append(button)
                }
            }
            let button = buttonArr[section]
            switchSelectedButton(button)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 添加表情到textView
        // 获取到表情
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        textView?.insertEmoticon(emoticon)
        // 当点击最近里面的表情,发现点击的和添加到textView上面的不是同一个,原因是数据发生改变,显示没有变化
        // 1.刷新数据
        //        collectionView.reloadSections(NSIndexSet(index: indexPath.section))
        
        // 2.当点击的是最近表情包得表情,不添加到最近表情包和排序
        
        if indexPath.item != 0 {
              // 添加 表情模型 到  最近表情包
            CZEmoticonPackage.addFavourite(emoticon)
        }
    }
}

// MARK: - 自定义表情cell
class CZEmotionCell: UICollectionViewCell {
    // MARK: - 属性
    /// 表情模型
    var emoticon: CZEmoticon? {
        didSet{
            // 设置内容
            // 1 .设置显示图片表情
//            print("emoticon.png\(emoticon?.pngPath)")
            if let pngPath = emoticon?.pngPath {
                emoticonButton.setImage(UIImage(contentsOfFile: pngPath), forState: UIControlState.Normal)
            } else { // 防止cell复用
                emoticonButton.setImage(nil, forState: UIControlState.Normal)
            }
            // 2. 设置显示emoji表情
            emoticonButton.setTitle(emoticon?.emoji, forState: UIControlState.Normal)
            //            if let emoji = emoticon?.emoji {
            //                emoticonButton.setTitle(emoji, forState: UIControlState.Normal)
            //            } else {
            //                emoticonButton.setTitle(nil, forState: UIControlState.Normal)
            //            }
            
            // 3. 判断是否是删除按钮模型，是的话，显示删除按钮
            if emoticon!.removeEmoticon {
                // 是删除按钮
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
            }
            
        }
    }
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        print("frame:\(frame)")
        
        prepareUI()
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(emoticonButton)
        // 设置frame
        emoticonButton.frame = CGRectInset(bounds, 4, 4) // 此处必须使用bounds,因为emotionButton相对于当前contentView的内部偏移
        // 设置title大小,为了使emoji表情，和图片表情一样大，emoji本身是文字
        emoticonButton.titleLabel?.font = UIFont.systemFontOfSize(32) // 32是图片表情的大小
        // 禁止按钮可以点击
        emoticonButton.userInteractionEnabled = false
        
    }
    
    // MARK: - 懒加载
    /// 表情按钮
    private lazy var emoticonButton: UIButton = UIButton()
}

// MARK: - 继承流水布局
/// 在collectionView布局之前设置layout的参数
class CZCollectionViewFlowLayout: UICollectionViewFlowLayout {
    // 重写 prepareLayout
    override func prepareLayout() {
        super.prepareLayout()
         // item 宽度
        let width = collectionView!.bounds.width / 7.0
        // item 高度
        let height = collectionView!.bounds.height / 3.0
        // 设置layout 的 itemSize
        itemSize = CGSize(width: width, height: height)
        // 滚动方向
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 间距
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        // 取消弹簧效果
        collectionView?.bounces = false
        // 取消滚动指示器
        collectionView?.showsHorizontalScrollIndicator = false
         // 分页显示
        collectionView?.pagingEnabled = true
        
        
    }
}
