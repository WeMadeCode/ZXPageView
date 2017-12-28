//
//  ZXPageStyle.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

public class ZXPageStyle:NSObject {
    
    //内容是否可以滚动
    public var isScrollEnable:Bool = true
    
    //字体高度
    public var titleHeight : CGFloat = 44
    //非选中字体颜色
    public var normalColor : UIColor = UIColor.gray
    //选中字体的颜色
    public var selectColor : UIColor = UIColor.orange
    //字体大小
    public var fontSize    : CGFloat = 15
    //字体间距
    public var titleMargin : CGFloat = 30
    
    //是否显示滚动条
    public var isShowBottomLine : Bool = true
    //滚动条颜色
    public var bottomLineColor : UIColor = UIColor.orange
    //滚动条高度
    public var bottomLineHeight : CGFloat = 2
    
    
    //是否支持标题缩放
    public var isScaleEnable : Bool = false
    //缩放大小
    public var maxScale : CGFloat = 1.2
    

    
    // pageControl的高度
    public var pageControlHeight : CGFloat = 20

    

}




