//
//  ZXPageStyle.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

public class ZXPageStyle:NSObject {
    
    /// 内容是否可以滚动
    public var isScrollEnable:Bool = true

    /// 顶部按钮属性
    public var titleHeight  : CGFloat = 44              // 字体高度
    public var normalColor  : UIColor = UIColor.gray    // 非选中字体颜色
    public var selectColor  : UIColor = UIColor.orange  // 选中字体的颜色
    public var fontSize     : CGFloat = 15              // 字体大小
    public var titleMargin  : CGFloat = 30              // 字体间距
    public var isDivideByScreen : Bool    = true        // 当标签过少时，是否会等分屏幕
    
    /// 滚动条属性
    public var isShowBottomLine  : Bool    = true           // 是否显示滚动条
    public var bottomLineColor   : UIColor = UIColor.orange // 滚动条颜色
    public var bottomLineHeight  : CGFloat = 2              // 滚动条高度
    public var cornerRadius      : CGFloat = 2              // 滚动条圆角
    public var isLongStyle       : Bool = true              // 是否为长条形

    
    /// 标题缩放属性
    public var isScaleEnable : Bool    = false  // 是否支持
    public var maxScale      : CGFloat = 1.2   // 缩放大小
    
    /// 是否需要显示背景
    public var isShowCoverView : Bool    = false         //是否展示背景色
    public var coverBgColor    : UIColor = UIColor.black //背景色颜色
    public var coverAlpha      : CGFloat = 0.4           //背景色透明度
    public var coverMargin     : CGFloat = 12            //背景边距
    public var coverHeight     : CGFloat = 30            //背景高度
    public var coverRadius     : CGFloat = 15            //背景圆角度
    
    
    
    /// pageControl的高度
    public var pageControlHeight : CGFloat = 20

    

}




