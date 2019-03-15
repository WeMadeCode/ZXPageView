//
//  ZXPageView.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

public class ZXPageView: UIView {
    
    private var defaultIndex    : Int
    private var style           : ZXPageStyle
    private weak var parentVc   : UIViewController!
    private var titles          : [String]
    private var childVcs        : [UIViewController]
    private lazy var titleView: ZXTitleView = {
        let titleFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.style.titleHeight)
        let titleView = ZXTitleView(frame: titleFrame, style: self.style, titles: self.titles , defaultIndex : self.defaultIndex)
        titleView.didSelectedTitle = { title,index in
            self.didFinishedScrollHandle?(title,index)
        }
        return titleView
    }()
    private lazy var contentView: ZXContentView = {
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - self.style.titleHeight)
        let contentView = ZXContentView(frame: contentFrame, childVcs: self.childVcs, parentVc: self.parentVc,style:self.style,defaultIndex : self.defaultIndex)
        return contentView
    }()
    
    public var didFinishedScrollHandle : ((_ title:String,_ index:Int) ->())?
    public init(frame: CGRect,style:ZXPageStyle,titles:[String],childVcs:[UIViewController],parentVc:UIViewController,defaultIndex:Int = 0){
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.defaultIndex = defaultIndex
        super.init(frame:frame)
        setupSubViews()
    }
    

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ZXPageView{
    /// 初始化控制器的UI
    private func setupSubViews(){
        //1.添加ZXtitleView
        addSubview(titleView)
        //2.创建ZXContentView
        addSubview(contentView)
        //3.设置代理
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
    
}





