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
    var parentVc : UIViewController

    
    init(frame: CGRect,style:ZXPageStyle,titles:[String],childVcs:[UIViewController],parentVc:UIViewController) {
        
        //在super.init()之前，需要保证所有的属性有被初始化
        //self.不能省略：在函数中，如果和成员属性产生歧义
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame:frame)
        
        
        setupSubViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ZXPageView{
    fileprivate func setupSubViews(){
    
        //1.创建ZXtitleView
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        let titleView = ZXTitleView(frame: titleFrame, style: style, titles: titles)
        titleView.backgroundColor = UIColor.randomColor
        addSubview(titleView)
        
        
        //2.创建ZXContentView
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = ZXContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        contentView.backgroundColor = UIColor.randomColor
        addSubview(contentView)
        
        //3.让ZXTitleView和ZXContentView进行交互
        titleView.delegate = contentView
        
    }
}
