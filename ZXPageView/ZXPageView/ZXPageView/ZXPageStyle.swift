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
    var isScrollEnable:Bool = false
   
    
    //字体高度
    var titleHeight : CGFloat = 44
    //非选中字体颜色
    var normalColor : UIColor = UIColor.white
    //选中字体的颜色
    var selectColor : UIColor = UIColor.orange
    //字体大小
    var fontSize    : CGFloat = 15
    //字体间距
    var titleMargin : CGFloat = 30
    
    
    //是否显示滚动条
    var isShowBottomLine : Bool = false
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


extension UIColor{
    
    /*
     在extension中扩充构造函数，只能扩充便利构造函数
     1>在init前需要加上关键字convenience
     2>在自定义的构造函数内部，必须明确通过self.init()调用其他的构造函数
     函数的重载
     1>函数名称相同，但是参数不同
     2>参数不同有两层函数: 1)参数的类型不同  2)参数的个数不同
     */
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat = 1.0) {
        self.init(red:r/255.0,green:g/255.0,blue:b/255.0,alpha:alpha)
    }
    
    
    /// 计算属性：只读属性
    class var randomColor : UIColor{
        
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
        
    }
    
    
    /// 通过16进制的值创建颜色
    /*
     ff0011
     0xFF0011
     ##ff0022
     */
    convenience init?(hex:String,alpha : CGFloat = 1.0) {
        
        //1.判断字符串长度是否大于等于6
        if hex.count < 6{
            return nil
        }
        
        //2.将所有字符串转成大写
        var hexString = hex.uppercased()
        
        //3.判断是否以0x/##
        if (hexString.hasPrefix("##") || hexString.hasPrefix("0x")) {
            //as 将String转成NSString
            hexString = (hexString as NSString).substring(from: 2)
            
        }
        
        //4.判断是否以#开头
        if hexString.hasPrefix("#") {
            hexString = (hexString as NSString).substring(from: 1)
        }
        
        //FF0011
        //5.获取RGB的字符串
        var range = NSRange(location: 0, length: 2)
        let rStr = (hexString as NSString).substring(with: range)
        range.location = 2
        let gStr = (hexString as NSString).substring(with: range)
        range.location = 4
        let bStr = (hexString as NSString).substring(with: range)
        
        //6.转换成10进制
        //UnsafeMutablePointer:指针/地址
        var r:UInt32 = 0
        var g:UInt32 = 0
        var b:UInt32 = 0
        
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        
        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b),alpha:alpha)
        
    }
    
    func getRGB() -> (CGFloat,CGFloat,CGFloat) {
        
        var red     :CGFloat = 0
        var green   :CGFloat = 0
        var blue    :CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red * 255,green * 255,blue * 255)
        
    }
    
}

