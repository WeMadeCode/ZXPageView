//
//  ZXPageView.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

class ZXPageView: UIView {
    
    var style : ZXPageStyle
    var titles : [String]
    var childVcs : [UIViewController]
    
    
    init(frame: CGRect,style:ZXPageStyle,titles:[String],childVcs:[UIViewController]) {
        
        //在super.init()之前，需要保证所有的属性有被初始化
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        super.init(frame:frame)
        
        
        setupSubViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ZXPageView{
    fileprivate func setupSubViews(){
    
        //创建标题
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        let titleView = ZXTitleView(frame: titleFrame, style: style, titles: titles)
        titleView.backgroundColor = UIColor.orange
        addSubview(titleView)
        
        
        //创建内容
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = ZXContentView(frame: contentFrame, childVcs: childVcs)
        contentView.backgroundColor = UIColor.purple
        addSubview(contentView)
        
        
        
    }
}
