//
//  ZXWaterView.swift
//  Pods-ZXPageView_Example
//
//  Created by Anthony on 2019/3/15.
//

import UIKit

public protocol ZXHorizontalViewDataSource : AnyObject {
     func numberOfSectionsInWaterView(_ waterView : ZXHorizontalView) -> Int
     func waterView(_ waterView : ZXHorizontalView, numberOfItemsInSection section: Int) -> Int
     func waterView(_ waterView : ZXHorizontalView, cellForItemAtIndexPath indexPath : IndexPath) -> UICollectionViewCell
}


@objc public protocol ZXHorizontalViewDelegate : AnyObject {
    @objc optional func waterView(_ waterView : ZXHorizontalView, didSelectedAtIndexPath indexPath : IndexPath)
}


public class ZXHorizontalView: UIView {

    public weak var dataSource  : ZXHorizontalViewDataSource?
    public weak var delegate    : ZXHorizontalViewDelegate?

    private var style : ZXPageStyle
    private var titles : [String]
    private var layout : ZXHorizontalViewLayout
    private lazy var currentSection : Int = 0


    private lazy var collectionView : UICollectionView = {
        let frame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight - style.pageControlHeight)
        let clv = UICollectionView(frame: frame, collectionViewLayout: layout)
        clv.isPagingEnabled = true
        clv.scrollsToTop = false
        clv.showsHorizontalScrollIndicator = false
        clv.dataSource = self
        clv.delegate = self
        return clv
    }()

    private lazy var pageControl : UIPageControl = {
        let frame = CGRect(x: 0, y: collectionView.frame.maxY, width: bounds.width, height: style.pageControlHeight)
        let page = UIPageControl(frame: frame)
        page.numberOfPages = 4
        page.isEnabled = false
        return page
    }()


    private lazy var titleView: ZXTitleView = {
        let titleFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.style.titleHeight)
        let titleView = ZXTitleView(frame: titleFrame, style: self.style, titles: self.titles , defaultIndex : 0)
        return titleView
    }()



    public init(frame: CGRect, style : ZXPageStyle, titles : [String], layout : ZXHorizontalViewLayout) {
        self.style = style
        self.titles = titles
        self.layout = layout
        super.init(frame: frame)
        setupSubView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubView() {
        // 1.添加titleView
        self.addSubview(titleView)
        // 2.添加collectionView
        self.addSubview(collectionView)
        // 3.添加UIPageControl
        self.addSubview(pageControl)
        // 4.监听titleView的点击xxx
        self.titleView.delegate = self
    }

}


// MARK:- 实现ZXTitleView的代理方法
extension ZXHorizontalView : ZXTitleViewDelegate {
    
    public func titleView(_ titleView: ZXTitleView, nextTitle: String, nextIndex: Int) {
        // 1.滚动到正确的位置
        let indexPath = IndexPath(item: 0, section: nextIndex)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        // 2.微调collectionView -- contentOffset
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        // 3.改变pageControl的numberOfPages
        let itemCount = dataSource?.waterView(self, numberOfItemsInSection: nextIndex) ?? 0
        pageControl.numberOfPages = (itemCount - 1) / (layout.rows * layout.cols) + 1
        pageControl.currentPage = 0
        
        // 4.记录最新的currentSection
        currentSection = nextIndex
    }
    
}


// MARK:- UICollectionView的数据源
extension ZXHorizontalView : UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource!.numberOfSectionsInWaterView(self)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.waterView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        return itemCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.waterView(self, cellForItemAtIndexPath: indexPath)
    }
}

// MARK:- UICollectionView的代理源
extension ZXHorizontalView : UICollectionViewDelegate {

   public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.waterView?(self, didSelectedAtIndexPath: indexPath)
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
        // 1.获取当前显示页中的某一个cell的indexPath
        let point = CGPoint(x: layout.sectionInset.left + collectionView.contentOffset.x, y: layout.sectionInset.top)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }

        // 2.如果发现组(section)发生了改变, 那么重新设置pageControl的numberOfPages
        if indexPath.section != currentSection {
            // 2.1.改变pageControl的numberOfPages
            let itemCount = dataSource?.waterView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.rows * layout.cols) + 1

            // 2.2.记录最新的currentSection
            currentSection = indexPath.section

            // 2.3.让titleView选中最新的title
            titleView.setCurrentIndex(currentSection)
        }

        // 3.显示pageControl正确的currentPage
        let pageIndex = indexPath.item / 8
        pageControl.currentPage = pageIndex
    }
}



// MARK:- 对外提供的函数
extension ZXHorizontalView {
   public func registerCell(_ cellClass : AnyClass?, identifier : String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

   public func registerNib(_ nib : UINib?, identifier : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    public func dequeueReusableCell(withReuseIdentifier : String, for indexPath : IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: withReuseIdentifier, for: indexPath)
    }
}
