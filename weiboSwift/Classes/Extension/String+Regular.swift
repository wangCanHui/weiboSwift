//
//  String+Regular.swift
//  正则表达式
//
//  Created by zhangping on 15/11/10.
//  Copyright © 2015年 zhangping. All rights reserved.
//

import Foundation

extension String {
    
    func linkSource() -> String {
        // 匹配的规则
        let pattern = ">(.*?)</a>"
        
        let regular = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
        
        // 匹配第一项
        let result = regular.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.characters.count))

        let count = result?.numberOfRanges ?? 0

        // 判断count是否>1
        if count > 1 {
            // 获取对应的范围
            let range = result!.rangeAtIndex(1) //rangeAtIndex（n）,n是匹配到的第几项索引，得到range再用字符串截取既可以拿到匹配出来的结果
            
            let text = (self as NSString).substringWithRange(range)

            return text
        } else {
            return "未知来源"
        }
    }
}