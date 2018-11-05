//
//  ZXPageView.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

protocol ZXPageViewDataSource:class {
    func numberOfSectionInPageView(_ pageView:ZXPageView) -> Int
    func pageView(_ pageView:ZXPageView,numberOfItemsInSection section:Int) -> Int
    func pageView(_ pageView:ZXPageView,cellForItemsAtIndexPath indexPath:IndexPath) -> UICollectionViewCell
}

@objc protocol ZXPageViewDelegate:class{
    @objc optional func pageView(_ pageView:ZXPageView,didSelectedAtIndexPath indexPath:IndexPath)
}


public class ZXPageView: UIView {
    weak var dataSource  : ZXPageViewDataSource?
    weak var delegate    : ZXPageViewDelegate?
    private var defaultIndex:Int
    private var style    : ZXPageStyle
    private var titles   = [String]()
    private var childVcs = [UIViewController]()
    private weak var parentVc : UIViewController!
    private var layout   : ZXPageViewLayout!
    private lazy var collectionView : UICollectionView = {
       let collectionFrame = CGRect(x: 0, y: self.style.titleHeight, width: self.bounds.width, height: self.bounds.height - self.style.titleHeight - self.style.pageControlHeight)
       let clv = UICollectionView(frame: collectionFrame, collectionViewLayout: self.layout)
           clv.isPagingEnabled = true
           clv.scrollsToTop = false
           clv.showsHorizontalScrollIndicator = false
           clv.dataSource = self
           clv.delegate = self
           return clv
    }()
    private lazy var pageControl : UIPageControl = {
        let pageControlFrame = CGRect(x: 0, y: collectionView.frame.maxY, width: bounds.width, height: style.pageControlHeight)
        let  pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.isEnabled = false
        return pageControl
    }()
    private lazy var currentSection : Int = 0
    
    lazy var titleView: ZXTitleView = {
        let titleFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.style.titleHeight)
        let titleView = ZXTitleView(frame: titleFrame, style: self.style, titles: self.titles)
        return titleView
    }()
    
    private lazy var contentView: ZXContentView = {
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = ZXContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc,style:style)
        return contentView
    }()
    
    
    public init(frame: CGRect,style:ZXPageStyle,titles:[String],childVcs:[UIViewController],parentVc:UIViewController,defaultIndex:Int = 0){
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.defaultIndex = defaultIndex
        super.init(frame:frame)
        setupSubViews()
    }
    
    public init(frame:CGRect,style:ZXPageStyle,titles:[String],layout:ZXPageViewLayout){
        self.style = style
        self.titles = titles
        self.layout = layout
        self.defaultIndex = 0
        super.init(frame: frame)
        setupCollection()
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
        
        //3.让ZXTitleView和ZXContentView进行交互
        titleView.delegate = contentView
        contentView.delegate = titleView
        
        //4.默认的滚动位置
        guard defaultIndex <= 0 || defaultIndex >= titles.count else {
            titleView.setDefaultConetnt(index:defaultIndex)
            return
        }
        
    }
    
    /// 初始化collectionView的UI
    private func setupCollection(){
        
        //1.添加ZXtitleView
        addSubview(titleView)
        
        //2.添加collectionView
        addSubview(collectionView)

        //3.添加UIPageController
        addSubview(pageControl)
        
        //4.监听titleView的点击
        titleView.delegate = self
    }
}


// MARK: - UICollectionView的数据源方法
extension ZXPageView : UICollectionViewDataSource{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSectionInPageView(self) ?? 0
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.pageView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1)/(layout.cols * layout.rows) + 1
        }
        return itemCount
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageView(self, cellForItemsAtIndexPath: indexPath)
    }
}


extension ZXPageView : UICollectionViewDelegate{
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageView?(self, didSelectedAtIndexPath: indexPath)
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewDidEndScroll()
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionViewDidEndScroll()
        }
    }
    
    func collectionViewDidEndScroll() {
        //1.获取当前显示页中的某一个cell的indexPath
        let point = CGPoint(x: layout.sectionInset.left + collectionView.contentOffset.x, y: layout.sectionInset.top)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return  }
    
        //2.如果发现组(section)发生了改变，那么重新设置pageControl的numberOfPages
        if indexPath.section != currentSection {
            //2.1改变pageControl的numberOfPages
            let itemCount = dataSource?.pageView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1)/(layout.rows * layout.cols) + 1
            
            //2.2记录最新的currentSection
            currentSection = indexPath.section
            
            //2.3让titleView选中最新的title
            titleView.setCurrentIndex(currentIndex: currentSection)
        }
        
        //3.显示pageController正确的currntPage
        let pageIndex = indexPath.item / 8
        pageControl.currentPage = pageIndex
        
    
    }
    
}


// MARK: - 实现ZXPageTitle的代理方法
extension ZXPageView : ZXTitleViewDelegate{
    
    public func nextTitleClick(_ titleView: ZXTitleView, nextTitle: String, nextIndex: Int) {
        //1.滚动到正确的位置
        let indexPath = IndexPath(item: 0, section: nextIndex)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        //2.微调collectionView的contentOffSet
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        //3.改变pageController的numberOfPages
        let itemCount = dataSource?.pageView(self, numberOfItemsInSection: nextIndex) ?? 0
        pageControl.numberOfPages = (itemCount - 1)/(layout.rows * layout.cols) + 1
        pageControl.currentPage = 0
        
        //4.记录最新的currentSection
        currentSection = nextIndex
    }
}



// MARK: - 对外提供的函数
extension ZXPageView{

    func registerCell(_ cellClass:AnyClass?,identifier:String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    
    func registerNib(_ nib:UINib?,identifier:String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell(withReuseIdentifier:String,for indexPath:IndexPath) -> UICollectionViewCell{
        return collectionView.dequeueReusableCell(withReuseIdentifier:withReuseIdentifier, for: indexPath)
    }
}


