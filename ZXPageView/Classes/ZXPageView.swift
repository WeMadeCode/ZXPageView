//
//  ZXPageView.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

@objc public protocol ZXPageViewDelegate:class {
    
    /// 展示当前页
    ///
    /// - Parameters:
    ///   - pageView: pageView
    ///   - currentTitle: 当前标题
    ///   - currentIndex: 当前index
    @objc optional func pageView(_ pageView:ZXPageView,currentTitle:String,currentIndex:Int)
    
    
    /// 展示下一页
    ///
    /// - Parameters:
    ///   - pageView: pageView
    ///   - nextTitle: 下一个标题
    ///   - nextIndex: 下一个标签
    func pageView(_ pageView:ZXPageView,nextTitle:String,nextIndex:Int)
}

@objc public protocol ZXPageViewDataSource {
    func titlesForPageView() -> [String]
    func contentForPageView() -> [UIViewController]
    func styleForPageView() -> ZXPageStyle
    @objc optional func defaultScrollIndex() -> Int
}


public class ZXPageView: UIView {
    private var dataSource  : ZXPageViewDataSource
    public weak var deleagte    : ZXPageViewDelegate?
   
    private lazy var titleView: ZXTitleView = {
        let style = self.dataSource.styleForPageView()
        let titles = self.dataSource.titlesForPageView()
        let index  = self.dataSource.defaultScrollIndex?() ?? 0
        let titleFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: style.titleHeight)
        let titleView = ZXTitleView(frame: titleFrame, style: style, titles: titles , defaultIndex : index)
        titleView.selectCurrent = {title,index in
            self.deleagte?.pageView?(self, currentTitle: title, currentIndex: index)
        }
        titleView.selectNext = { title,index in
            self.deleagte?.pageView(self, nextTitle: title, nextIndex: index)
        }
        return titleView
    }()
    
    private lazy var contentView: ZXContentView = {
        let style = self.dataSource.styleForPageView()
        let childVcs = self.dataSource.contentForPageView()
        let index  = self.dataSource.defaultScrollIndex?() ?? 0
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = ZXContentView(frame: contentFrame, childVcs: childVcs,style:style)
        return contentView
    }()

    
    
    public init(dataSource:ZXPageViewDataSource) {
        self.dataSource = dataSource
        super.init(frame:CGRect.zero)
        setupSubViews()
        addConstraint()
    }
    
    public convenience init(frame: CGRect,dataSource:ZXPageViewDataSource){
        self.init(dataSource: dataSource)
        setupSubViews()
        addConstraint()
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
    
    // obj1.property1 =（obj2.property2 * multiplier）+ constant value
    private func addConstraint(){
        let style = self.dataSource.styleForPageView()
        
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleViewWidth = NSLayoutConstraint(item: self.titleView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 0, constant: self.bounds.width)
        self.titleView.addConstraint(titleViewWidth)
        
        let titleViewHeight = NSLayoutConstraint(item: self.titleView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 0, constant: style.titleHeight)
        self.titleView.addConstraint(titleViewHeight)
        
        
        let titleViewTop = NSLayoutConstraint(item: self.titleView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        self.addConstraint(titleViewTop)
        
        
        let titleViewLeft = NSLayoutConstraint(item: self.titleView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        self.addConstraint(titleViewLeft)
        
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentViewTop = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.titleView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        self.addConstraint(contentViewTop)
        
        
        let contentViewLeft = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        self.addConstraint(contentViewLeft)
        
        
        let contentViewWidth = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 0, constant: self.bounds.width)
        self.contentView.addConstraint(contentViewWidth)
        
        
        let contentViewButton = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        self.addConstraint(contentViewButton)
        
        
    }
    
    
    
    
}
