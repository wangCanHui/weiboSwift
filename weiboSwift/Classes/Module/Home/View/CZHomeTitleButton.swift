//
//  CZHomeTitleButton.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/31.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZHomeTitleButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        
        imageView?.frame.origin.x = (titleLabel?.bounds.width)! + 3
    }

}
