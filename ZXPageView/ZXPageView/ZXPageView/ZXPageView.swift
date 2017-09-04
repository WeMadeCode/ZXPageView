//
//  ZXPageView.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit


private let kCollectionViewCellID = "kCollectionViewCellID"

class ZXPageView: UIView {
    // MARK: 定义属性
    fileprivate var style : ZXPageStyle
    fileprivate var titles : [String]
    fileprivate var childVcs : [UIViewController]!
    fileprivate var parentVc : UIViewController!
    fileprivate var layout : ZXPageViewLayout!

    fileprivate lazy var titleView: ZXTitleView = {
        let titleFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.style.titleHeight)
        let titleView = ZXTitleView(frame: titleFrame, style: self.style, titles: self.titles)
        titleView.backgroundColor = UIColor.blue
        return titleView
    }()
    

    // MARK: 构造函数
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
    
    
    init(frame:CGRect,style:ZXPageStyle,titles:[String],layout:ZXPageViewLayout) {
        self.style = style
        self.titles = titles
        self.layout = layout
        super.init(frame: frame)
        setupCollection()
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ZXPageView{
    
    
    /// 初始化collectionView的UI
    fileprivate func setupCollection(){
        
        //1.添加ZXtitleView
        addSubview(titleView)
        
        
        //2.添加collectionView
        let collectionFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight - style.pageControlHeight)

        let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCollectionViewCellID)
        addSubview(collectionView)

        
        //3.添加UIPageController
        let pageControlFrame = CGRect(x: 0, y: collectionView.frame.maxY, width: bounds.width, height: style.pageControlHeight)
        let pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 4
        addSubview(pageControl)
        
        
        
        
    }
    
    /// 初始化控制器的UI
    fileprivate func setupSubViews(){
    
        //1.添加ZXtitleView
        addSubview(titleView)
        
        
        //2.创建ZXContentView
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = ZXContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        contentView.backgroundColor = UIColor.randomColor
        addSubview(contentView)
        
        //3.让ZXTitleView和ZXContentView进行交互
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}

extension ZXPageView : UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor
        return cell
        
    }
    
}

