//
//  CZStatusPictureView.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/1.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZStatusPictureView: UICollectionView {

    // MARK: - 属性
    /// cell重用表示
    private let statusPictureIdentifier = "statusPictureIdentifier"
    /// 布局
    private let layout = UICollectionViewFlowLayout()
    
    var status: CZStatus? {
        didSet {
//            sizeToFit()
            reloadData()
        }
    }
    
    // 这个方法是 sizeToFit调用的,而且 返回的 CGSize 系统会设置为当前view的size
    override func sizeThatFits(size: CGSize) -> CGSize {
        return calcPictureViewSize()
    }
    
    /// 根据微博模型,计算配图的尺寸
    func calcPictureViewSize() -> CGSize {
        // itemSize
        let itemSize: CGSize = CGSizeMake(90, 90)
        
        // 设置默认值
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 间距
        let margin:CGFloat = 10
        
        // 根据模型的图片数量来计算尺寸
        let count = status?.pictureUrls?.count ?? 0
        // 没有图片
        if count == 0 {
            return CGSizeZero
        }
        
        if count == 1{
            let size = CGSizeMake(150, 120)
            layout.itemSize = size
            return size
        }
        
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        
        // 4 张图片
        if count == 4 {
          return  CGSizeMake(itemSize.width*2 + margin, itemSize.height*2 + margin)
        }
        
        let column = 3
        // 剩下 2, 3, 5, 6, 7, 8, 9
        // 计算行数: 公式: 行数 = (图片数量 + 列数 -1) / 列数
        let row = (count - 1) / column + 1
        
         // 宽度公式: 宽度 = (列数 * item的宽度) + (列数 - 1) * 间距
        let width = CGFloat(column) * itemSize.width + CGFloat(column - 1) * margin
        
        // 高度公式: 高度 = (行数 * item的高度) + (行数 - 1) * 间距
        let height = CGFloat(row) * itemSize.height + CGFloat(row - 1) * margin
        
        return CGSizeMake(width, height)
    }
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init() {
        super.init(frame: CGRectZero, collectionViewLayout: layout)
        // 设置背景
        backgroundColor = UIColor.clearColor()
        // 设置数据源
        dataSource = self
        // 注册cell
        registerClass(CZStatusPictureViewCell.self, forCellWithReuseIdentifier: statusPictureIdentifier)
        
    }
}
// MARK: - 扩展 CZStatusPictureView 类,实现 UICollectionViewDataSource协议
extension CZStatusPictureView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let name = status?.user?.name
//        print("---name:\(name)---count\(status?.pictureUrls?.count)")
//        if name == "iOS终结者" {
//            print("---iOS终结者frame:\(frame)")
//        }
        return status?.pictureUrls?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(statusPictureIdentifier, forIndexPath: indexPath) as! CZStatusPictureViewCell
        
        // 模型能直接提供图片的URL数组,外面使用就比较简单
        cell.imageUrl = status?.pictureUrls?[indexPath.item]
//        let name = status?.user?.name
//        print("---name:\(name)---imageUrl\(cell.imageUrl)")
        
        return cell
    }
    
}
// 自定义cell  显示图片
class CZStatusPictureViewCell: UICollectionViewCell {
    // MARK: - 属性
    var imageUrl: NSURL? {
        didSet {
            iconView.cz_setImageWithURL(imageUrl)
        }
    }
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(iconView)
        
        // 设置约束
        // 填充父控件
        iconView.ff_Fill(contentView)
        
    }
    
    // MARK: - 懒加载
    // 图片
    private lazy var iconView: UIImageView = {
       let iconView = UIImageView()
         // 设置内容模式,防止图片拉伸填充变形
        iconView.contentMode = UIViewContentMode.ScaleAspectFill
        iconView.clipsToBounds = true
        return iconView
    }()
    
}
