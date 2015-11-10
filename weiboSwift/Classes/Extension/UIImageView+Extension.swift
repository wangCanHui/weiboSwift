//
//  UIImageView+Extension.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/11/3.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit
//import SDWebImage
/// 隔离SDWebImage
extension UIImageView {
    func cz_setImageWithURL(url: NSURL!) {
        sd_setImageWithURL(url)
    }
    
    func cz_setImageWithURL(url: NSURL!, placeholderImage placeholder: UIImage!) {
        sd_setImageWithURL(url, placeholderImage :placeholder )
        sd_cancelCurrentAnimationImagesLoad()
    }
    
}

