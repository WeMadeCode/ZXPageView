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
    
    /// 标题数据源
    ///
    /// - Returns: 标题
    func titlesForPageView() -> [String]
    
    /// 内容数据源
    ///
    /// - Returns: 内容
    func contentForPageView() -> [UIViewController]
    
    /// 样式数据源
    ///
    /// - Returns: 样式
    func styleForPageView() -> ZXPageStyle
    
    /// 默认选中的位置
    ///
    /// - Returns: 位置
    @objc optional func defaultScrollIndex() -> Int
    
    /// 默认内容尺寸，AutoLayout布局时必须设置改大小，Frame布局可以不用设置改大小
    ///
    /// - Returns: 尺寸
    @objc optional func defaultPageSize() -> CGSize
    
}


public class ZXPageView: UIView {
    public weak var dataSource : ZXPageViewDataSource?{
        didSet{
            addSubViews()
            addConstraint()
        }
    }
    public weak var delegate   : ZXPageViewDelegate?
   
    private lazy var titleView: ZXTitleView = {
        let style  = self.dataSource!.styleForPageView()
        let titles = self.dataSource!.titlesForPageView()
        let index  = self.dataSource?.defaultScrollIndex?() ?? 0
        let width = self.dataSource?.defaultPageSize?().width ?? self.bounds.width
        let titleFrame = CGRect(x: 0, y: 0, width: width , height: style.titleHeight)
        let titleView = ZXTitleView(frame: titleFrame, style: style, titles: titles , defaultIndex : index)
        return titleView
    }()
    
    private lazy var contentView: ZXContentView = {
        let style = self.dataSource!.styleForPageView()
        let childVcs = self.dataSource!.contentForPageView()
        let index  = self.dataSource?.defaultScrollIndex?() ?? 0
        let width = self.dataSource?.defaultPageSize?().width ?? self.bounds.width
        let height = self.dataSource?.defaultPageSize?().height ?? self.bounds.height - style.titleHeight
        let frame = CGRect(x: 0, y: style.titleHeight, width: width, height: height)
        let contentView = ZXContentView(frame:frame,childVcs: childVcs,style:style,defaultIndex:index)
        return contentView
    }()

    
    
    public init() {
        super.init(frame:CGRect.zero)
    }

    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension ZXPageView:ZXTitleViewDelegate{
    public func titleView(_ titleView: ZXTitleView, currentTitle: String, currentIndex: Int) {
        self.delegate?.pageView?(self, currentTitle: currentTitle, currentIndex: currentIndex)
    }
    public func titleView(_ titleView: ZXTitleView, nextTitle: String, nextIndex: Int) {
        self.contentView.scrollToSpecifiedIndex(nextIndex)
        self.delegate?.pageView(self, nextTitle: nextTitle, nextIndex: nextIndex)
    }
}


extension ZXPageView :ZXContentViewDelegate{
    func contentView(_ contentView: ZXContentView, index: Int) {
        self.titleView.setCurrentIndex(index)
    }
    
    func contentView(_ contentView: ZXContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        self.titleView.setCurrentProgress(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
}




extension ZXPageView{
    /// 初始化控制器的UI
    private func addSubViews(){
        //1.添加ZXtitleView
        addSubview(titleView)
        //2.创建ZXContentView
        addSubview(contentView)
        //3.设置代理
        titleView.delegate = self
        contentView.delegate = self
    }
    
    // obj1.property1 =（obj2.property2 * multiplier）+ constant value
    private func addConstraint(){
    
        let style = self.dataSource!.styleForPageView()
        
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleViewTop = NSLayoutConstraint(item: self.titleView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        self.addConstraint(titleViewTop)
        
        let titleViewLeft = NSLayoutConstraint(item: self.titleView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        self.addConstraint(titleViewLeft)
        
        let titleViewRight = NSLayoutConstraint(item: self.titleView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0)
        self.addConstraint(titleViewRight)
        
        let titleViewHeight = NSLayoutConstraint(item: self.titleView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 0, constant: style.titleHeight)
        self.titleView.addConstraint(titleViewHeight)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentViewTop = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.titleView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        self.addConstraint(contentViewTop)
        
        let contentViewLeft = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        self.addConstraint(contentViewLeft)
        
        let contentViewRight = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0)
        self.addConstraint(contentViewRight)
        
        let contentViewBottom = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        self.addConstraint(contentViewBottom)
    }

}
