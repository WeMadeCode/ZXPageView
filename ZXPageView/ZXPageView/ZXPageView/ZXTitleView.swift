//
//  ZXTitleView.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

class ZXTitleView: UIView {

    
    fileprivate var style:ZXPageStyle
    fileprivate var titles:[String]
    
    init(frame:CGRect,style:ZXPageStyle,titles:[String]) {
        
        self.style = style
        self.titles = titles
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
