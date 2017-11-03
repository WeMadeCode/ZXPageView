//
//  ZXPageStyle.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

class ZXPageStyle {
    
    
    //是否可以滚动
    var isScrollEnable:Bool = true
    //字体高度
    var titleHeight : CGFloat = 44
    //非选中字体颜色
    var normalColor : UIColor = UIColor.gray
    //选中字体的颜色
    var selectColor : UIColor = UIColor.orange
    //字体大小
    var fontSize    : CGFloat = 15
    //字体间距
    var titleMargin : CGFloat = 30
    
    //是否显示滚动条
    var isShowBottomLine : Bool = true
    //滚动条颜色
    var bottomLineColor : UIColor = UIColor.orange
    //滚动条高度
    var bottomLineHeight : CGFloat = 2
    
    
    //是否支持标题缩放
    var isScaleEnable : Bool = false
    //缩放大小
    var maxScale : CGFloat = 1.2
    
   
    //是否需要显示的遮盖
    var isShowCoverView : Bool = false
    //遮盖背景色
    var coverBgColor :  UIColor = UIColor.black
    //遮盖透明度
    var coverAlpha :  CGFloat = 0.4
    //遮盖边界
    var coverMargin : CGFloat = 8
    //遮盖高度
    var coverHeight : CGFloat = 25
    //遮盖圆角
    var coverRadius : CGFloat = 12
    
    
    // pageControl的高度
    var pageControlHeight : CGFloat = 20

    

}




