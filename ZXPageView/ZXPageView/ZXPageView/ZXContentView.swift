//
//  ZXContentView.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

class ZXContentView: UIView {

    fileprivate var childVcs:[UIViewController]
    
    init(frame:CGRect,childVcs:[UIViewController]) {
        self.childVcs = childVcs
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
