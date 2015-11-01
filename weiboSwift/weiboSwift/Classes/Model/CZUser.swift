//
//  CZUser.swift
//  weiboSwift
//
//  Created by 王灿辉 on 15/10/31.
//  Copyright © 2015年 王灿辉. All rights reserved.
//

import UIKit

class CZUser: NSObject {
    /// 字符串型的用户UID
    var idstr: String?
    
    /// 友好显示名称
    var name: String?
    
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    
    /// verified_type 没有认证:-1   认证用户:0  企业认证:2,3,5  达人:220
    var verified_type: Int = -1
    
    /// 计算性属性，返回认证图片
    var verifiedTypeImage: UIImage? {
        switch verified_type {
        case 0:
            return UIImage(named: "avatar_vip")
        case 2,3,5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:
            return UIImage(named: "avatar_grassroot")
        default:
            return nil
            
        }
    }
    
    /// 会员等级 1-6
    var mbrank: Int = 0
    
    // 计算型属性,根据不同会员等级返回不同的图片
    var mbrankImage: UIImage? {
        if mbrank > 0 && mbrank <= 6 {
            return UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        return nil
    }
    
    /// 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    // 字典的key在模型中找不到
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String {
        let properties = ["idstr", "name", "profile_image_url", "verified_type", "mbrank"]
        
        return "\n\t用户模型:\(dictionaryWithValuesForKeys(properties))"

    }
    
}
