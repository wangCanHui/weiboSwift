//
//  CZStatusPictureView.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/1.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
import SDWebImage

// 在类外面全局的,任何地方都可以访问
/// 点击cell通知的名称
let CZStatusPictureViewCellSelectedPictureNotification = "CZStatusPictureViewCellSelectedPictureNotification"

let CZStatusPictureViewCellSelectedPictureModelsKey = "CZStatusPictureViewCellSelectedPictureModelsKey"

let CZStatusPictureViewCellSelectedPictureIndexKey = "CZStatusPictureViewCellSelectedPictureIndexKey"

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
        
        // 在这个时候需要有图片,才能获取到图片的大小,缓存图片越早越好
        if count == 1{
            // 获取图片的url路径
            let urlStr = status!.pictureUrls![0].absoluteString
            // 获取缓存好的图片,缓存的图片可能没有成功
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlStr)
            var size = CGSizeMake(150, 120)
            // 当有图片的时候在来赋值
            if image != nil {
                size = image.size
            }
            // 如果图片宽度太小
            if size.width < 40 {
                size.width = 40
            }
            layout.itemSize = size
            return size
        }
        
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        
        // 4 张图片
        if count == 4 {
            let width = 2 * itemSize.width + margin
            return CGSize(width: width, height: width)
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
        // 设置代理
        delegate = self
        // 注册cell
        registerClass(CZStatusPictureViewCell.self, forCellWithReuseIdentifier: statusPictureIdentifier)
        
    }
}
// MARK: - 扩展 CZStatusPictureView 类,实现 UICollectionViewDataSource,UICollectionViewDelegate协议
extension CZStatusPictureView: UICollectionViewDataSource ,UICollectionViewDelegate{
    
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //print("所有url地址:\(status?.largePictureURLs)")
        // 点击的哪个cell
        // indexPath.item
        // 代理,闭包,通知
        /*
        代理:
        1. 1对1 (xmpp的可以一对多)
        2. 嵌套层次不是很深
        3. 代理可以有返回值
        通知:
        1. 1对多
        2. 嵌套层次无所谓
        3. 无法获取返回值
        */
        
        // 想把 url 和 点击的indexPath.item传给控制器
        
        // 提供模型
        var models = [CZPhotoBrowserModel]()
        let count = status?.largePictureUrls?.count ?? 0
        for i in 0..<count {
             // 创建模型
            let model = CZPhotoBrowserModel()
            // 获取大图的url
            model.url = status?.largePictureUrls?[i]
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as! CZStatusPictureViewCell
            // 获取显示的imageView
            model.imageView = cell.iconView
            
            models.append(model)
        }
        
        
        let userInfo: [String: NSObject] = [
            CZStatusPictureViewCellSelectedPictureModelsKey: models,
            CZStatusPictureViewCellSelectedPictureIndexKey: indexPath.item
        ]
        
        NSNotificationCenter.defaultCenter().postNotificationName(CZStatusPictureViewCellSelectedPictureNotification, object: self, userInfo: userInfo)
    }
    
    
}
// 自定义cell  显示图片
class CZStatusPictureViewCell: UICollectionViewCell {
    // MARK: - 属性
    var imageUrl: NSURL? {
        didSet {
            iconView.cz_setImageWithURL(imageUrl)
            // 判断是否是gif图片
            let isGif = (imageUrl!.absoluteString as NSString).pathExtension.lowercaseString == "gif"
            gifImageView.hidden = !isGif
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
        contentView.addSubview(gifImageView)
        
        // 设置约束
        // 填充父控件
        iconView.ff_Fill(contentView)
        gifImageView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: contentView, size: nil)
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
     /// gif标示
    private lazy var gifImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
}
