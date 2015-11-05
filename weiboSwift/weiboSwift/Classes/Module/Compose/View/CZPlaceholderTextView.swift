
//
//  CZPlaceHolderTextView.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/4.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZPlaceholderTextView: UITextView {
    // MARK: - 属性
    /// 占位文本
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
             // 设置占位文本的font 等于 UITextView的font
            placeholderLabel.font = font
            placeholderLabel.sizeToFit()
        }
    }
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        prepareUI()
        
        // 添加textView的文本内容改变通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textDidChange", name: UITextViewTextDidChangeNotification, object: self)
    }
    
    // 移除通知
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // 自己文字改变了
    func textDidChange() {
        // 能到这里来说明是当前这个textView文本改变了
        // 判断文本是否为空: hasText()
        // 当有文字的时候就隐藏

        placeholderLabel.hidden = hasText()
    }
    
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加自控件
        addSubview(placeholderLabel)
        // 设置约束
        placeholderLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: nil, offset: CGPoint(x: 5, y: 8))
        
    }
    // MARK: - 懒加载
    // 添加占位文本
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel(fontSize: 18, textColor: UIColor.lightGrayColor())
        return label
    }()
}

/*
    当外部控制器也实现代理方法的话，自身做代理就会没有效果，所以此处监听文本框内容的改变使用通知
*/
// MARK: - 扩展 CZPlaceholderTextView 实现 UITextViewDelegate 协议
//extension CZPlaceholderTextView: UITextViewDelegate {
//
//    /// 当textView文字改变的时候会调用
//    func textViewDidChange(textView: UITextView) {
//        // 判断文本是否为空: hasText()
//        // 当有文字的时候就隐藏
//        placeholderLabel.hidden = hasText()
//    }
//}
