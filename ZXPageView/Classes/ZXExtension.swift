//
//  ZXExtension.swift
//  ZXPageView
//
//  Created by Anthony on 2017/11/2.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat = 1.0) {
        self.init(red:r/255.0,green:g/255.0,blue:b/255.0,alpha:alpha)
    }
    
 
    /// 获取RGB
    ///
    /// - Returns: RGB
    func getRGB() -> (CGFloat,CGFloat,CGFloat) {
        var red     :CGFloat = 0
        var green   :CGFloat = 0
        var blue    :CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red * 255,green * 255,blue * 255)
    }

}

