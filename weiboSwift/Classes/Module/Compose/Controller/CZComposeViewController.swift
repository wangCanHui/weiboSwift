//
//  CZComposeViewController.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/4.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
import SVProgressHUD

let CZComposeViewControllerSendStatusSuccessNotification = "CZComposeViewControllerSendStatusSuccessNotification"

class CZComposeViewController: UIViewController {
    // MARK: - 属性
    /// toolBar底部约束
    
    private var toolBarBottomCons: NSLayoutConstraint?
    /// 照片选择器控制器view的底部约束
    private var photoSelectorViewBottomCons: NSLayoutConstraint?
    /// 微博内容的最大长度
    private let statusMaxLength = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 需要设置背景颜色,不然弹出时动画有问题
        view.backgroundColor = UIColor.whiteColor()
        
        prepareUI()
         // 添加键盘frame改变的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    /*
    notification:NSConcreteNotification 0x7f8fea5a4e20 {name = UIKeyboardDidChangeFrameNotification; userInfo = {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.25";    // 动画时间
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 258}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 796}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 538}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 258}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}"; // 键盘最终的位置
    UIKeyboardIsLocalUserInfoKey = 1;
    }}
    */
    
    /// 键盘frame改变
    func willChangeFrame(notification:NSNotification) {
//        print("notification:\(notification)")
        // 获取键盘最终位置
        let endFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        // 动画时间
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        
        toolBarBottomCons?.constant = -(UIScreen.height() - endFrame.origin.y) // 相对于view的底部约束的，监听键盘的弹出和隐藏
        UIView.animateWithDuration(duration) { () -> Void in
           self.view.layoutIfNeeded()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 258)) // 键盘的高度是258
//        view.backgroundColor = UIColor.redColor()
        // 自定义键盘其实就是给 textView.inputView 赋值
//        textView.inputView = view
        // 图片现在器隐藏的时候才需要显示键盘，要不让每次选择一张图片返回发微博界面，都会调用此方法叫出键盘
        if photoSelectorViewBottomCons?.constant != 0 {
            textView.becomeFirstResponder()
        }
    }

    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件,(顺序不能错，以免需要显示在上面的被遮挡)
        view.addSubview(textView)
        view.addSubview(photoSelectorVC.view)
        view.addSubview(toolBar)
        view.addSubview(lengthTipLabel)
        
        // 设置导航栏
        setupNavigationBar()
        // 设置输入框textView
        setupTextView()
        // 设置图片选择器
        preparePhotoSelectorView()
        // 设置toolBar
        setupToolBar()
        // 设置可输入长度提示按钮
        setupLengthTipLabel()
        
    }
    /// 设置导航栏
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        navigationItem.rightBarButtonItem?.enabled = false //禁用
        setupTitleView()
    }
    
    /// 设置导航栏标题
    private func setupTitleView() {
        let prefix = "发微博"
        // 获取用户的名称
        if let name = CZUserAccount.loadAccount()?.name {
            let titleLabel = UILabel()
            // 设置文本属性
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.font = UIFont.systemFontOfSize(14)
            // 有用户名
            let text = prefix + "\n" + name
            let attrText = NSMutableAttributedString(string: text)
            // 设置属性文本的属性
            let range = (text as NSString).rangeOfString(name)
            attrText.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(12),NSForegroundColorAttributeName:UIColor.lightGrayColor()], range: range)
            // 顺序不要搞错
            titleLabel.attributedText = attrText
            titleLabel.sizeToFit()
            navigationItem.titleView = titleLabel
            
        }else {
            // 没有用户名
            navigationItem.title = prefix
        }
        
    }
    
     /// 设置toolBar
    private func setupToolBar() {
        
         // 添加约束
        let cons = toolBar.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.width(), height: 44))
        // 获取底部约束
        toolBarBottomCons = toolBar.ff_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        // 创建toolBar item
        var items = [UIBarButtonItem]()
        
        // 每个item对应的图片名称
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "picture"],
            ["imageName": "compose_trendbutton_background", "action": "trend"],
            ["imageName": "compose_mentionbutton_background", "action": "mention"],
            ["imageName": "compose_emoticonbutton_background", "action": "emoticon"],
            ["imageName": "compose_addbutton_background", "action": "add"]]
        
//        var index = 0
        for dict in itemSettings {
            // 获取图片的名称
            let imageName = dict["imageName"]!
            // 获取图片对应点点击方法名称
            let action = dict["action"]!
            
            let item = UIBarButtonItem(imageName: imageName)
             // 获取item里面的按钮
            let button = item.customView as! UIButton
            button.addTarget(self, action: Selector(action), forControlEvents: UIControlEvents.TouchUpInside)
            items.append(item)
             // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
//            index ++ 
        }
        // 移除最后一个弹簧
        items.removeLast()
        toolBar.items = items
        
    }
    
     /// 设置textView
    private func setupTextView() {
        
        /*
        前提: (UITextView继承自UIScrollView)
        1.scrollView所在的控制器属于某个导航控制器
        2.scrollView控制器的view或者控制器的view的第一个子view
        */
        // scrollView会自动设置Insets, 比如scrollView所在的控制器属于某个导航控制器contentInset.top = 64
        //        automaticallyAdjustsScrollViewInsets = true  // Defaults to YES
        
        // 设置约束
         // 相对控制器的view的内部左上角
        textView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: view, size: nil)
         // 相对toolBar顶部右上角
        textView.ff_AlignVertical(type: ff_AlignType.TopRight, referView: toolBar, size: nil)
    }
    
      /// 准备 显示微博剩余长度 label
    private func setupLengthTipLabel() {
        // 设置约束
        lengthTipLabel.ff_AlignVertical(type: ff_AlignType.TopRight, referView: toolBar, size: nil, offset: CGPoint(x: -8, y: -8))
    }
    
    /// 准备 照片选择器
    private func preparePhotoSelectorView() {
        // 照片选择器控制器的view
        let photoSelectorView = photoSelectorVC.view
        // 设置约束
        photoSelectorView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["psv": photoSelectorView]
        // 水平
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[psv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        // 高度
        view.addConstraint(NSLayoutConstraint(item: photoSelectorView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0.6, constant: 0))
        // 底部重合，偏移photoSelectorView的高度，使初始位置隐藏
        photoSelectorViewBottomCons = NSLayoutConstraint(item: photoSelectorView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: view.bounds.size.height * 0.6)
        view.addConstraint(photoSelectorViewBottomCons!)
        
    }
    
    // MARK: - 按钮点击事件
    /// 关闭控制器
    @objc private func close() {
        // 关闭sv提示
        SVProgressHUD.dismiss()
        // 关闭键盘
        textView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
     /// 发微博
    func sendStatus() {
        // 获取textView的文本内容发送给服务器
        let text = textView.emoticonText()
        // 判断微博内容的长度是否超出， 超出不发送
        let statusLength = text.characters.count
        if statusMaxLength - statusLength < 0 {
            // 微博内容超出,提示用户
            SVProgressHUD.showErrorWithStatus("微博长度超出", maskType: SVProgressHUDMaskType.Black)
            return
        }
         // 获取图片选择器中的图片
        let image = photoSelectorVC.photos.first
         // 显示正在发送
        SVProgressHUD.showWithStatus("正在发布微博...", maskType: SVProgressHUDMaskType.Black)
        // 发送微博
        CZNetworkTools.sharedInstance.sendStatus(image, status: text) { (result, error) -> Void in
            if error != nil {
                print("error:\(error)")
                SVProgressHUD.showErrorWithStatus("发布微博失败...", maskType: SVProgressHUDMaskType.Black)
                return
            }
            // 发送成功, 直接关闭正在发送界面
            self.close()
            // 刷新微博（下拉刷新）
            NSNotificationCenter.defaultCenter().postNotificationName(CZComposeViewControllerSendStatusSuccessNotification, object: self)
        }
    }
    
    func picture() {
        // 让照片选择器的view移动上来
        photoSelectorViewBottomCons?.constant = 0
        // 退下键盘
        textView.resignFirstResponder()
        // 动画效果
        UIView.animateWithDuration(0.25) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func trend() {
        print("#")
    }
    
    func mention() {
        print("@")
    }
    
    func emoticon() {
         print("切换前表情键盘:\(textView.inputView)")
        // 先让键盘退回去
        textView.resignFirstResponder()
        // 延时0.25
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(250 * USEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            // 如果inputView == nil 使用的是系统的键盘,切换到自定的键盘
            // 如果inputView != nil 使用的是自定义键盘,切换到系统的键盘
            self.textView.inputView = self.textView.inputView == nil ? self.emoticonVC.view : nil
            
            // 弹出键盘
            self.textView.becomeFirstResponder()
            
            print("切换后表情键盘:\(self.textView.inputView)")
        }

        
    }
    
    func add() {
        print("加号")
    }

    // MARK: - 懒加载
    /// toolBar
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return toolBar
    }()
    /*
    iOS中可以让用户输入的控件:
    1.UITextField:
    1.只能显示一行
    2.可以有占位符
    3.不能滚动
    
    2.UITextView:
    1.可以显示多行
    2.没有占位符
    3.继承UIScrollView,可以滚动
    */
    /// textView
    private lazy var textView: CZPlaceholderTextView = {
       let textView = CZPlaceholderTextView()
        // 当textView被拖动的时候就会将键盘退回,textView能拖动
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        textView.bounces = true // 默认是ture,只有此属性是true，alwaysBounceVertical设置为true才有效
        textView.alwaysBounceVertical = true
        textView.font = UIFont.systemFontOfSize(18)
        textView.backgroundColor = UIColor.whiteColor()
        textView.textColor = UIColor.blackColor()
        // 设置占位文本
        textView.placeholder = "分享新鲜事..."
        // 设置顶部的偏移
//        textView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        // 设置控制器作为textView的代理来监听textView文本的改变
        textView.delegate = self
        return textView
    }()
    
    /// 表情键盘控制器
    private lazy var emoticonVC: CZEmoticonViewController = {
        let emoticonVC = CZEmoticonViewController()
         // 设置textView
        emoticonVC.textView = self.textView
        return emoticonVC
    }()
    /// 显示微博剩余长度
    private lazy var lengthTipLabel: UILabel = {
        let label = UILabel(fontSize: 12, textColor: UIColor.lightGrayColor())
        label.text = String(self.statusMaxLength)
        return label
    }()
    /// 照片选择器的控制器
    private lazy var photoSelectorVC: CZPhotoSelectorViewController = {
        let photoSelectorVC = CZPhotoSelectorViewController()
        // 让照片选择控制器被被人管理
        self.addChildViewController(photoSelectorVC)
        return photoSelectorVC
    }()
}



extension CZComposeViewController: UITextViewDelegate {
    /// textView文本改变的时候调用
    func textViewDidChange(textView: UITextView) {
        // 当textView 有文本的时候,发送按钮可用,
        // 当textView 没有文本的时候,发送按钮不可用
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        // 计算剩余微博的长度
        let length = statusMaxLength - textView.emoticonText().characters.count // 注意此处使用emotionText,这样才能包含表情图片占的字符
        
        lengthTipLabel.text = String(length)
        // 判断 length 大于等于0显示灰色, 小于0显示红色
        lengthTipLabel.textColor = length < 0 ? UIColor.redColor() : UIColor.lightGrayColor()
    }
}
