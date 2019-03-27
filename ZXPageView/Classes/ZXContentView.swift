//
//  ZXContentView.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

protocol ZXContentViewDelegate:class {
    func contentView(_ contentView:ZXContentView,inIndex:Int)
    func contentView(_ contentView:ZXContentView,sourceIndex:Int,targetIndex:Int,progress:CGFloat)
}

private let kContentCellId = "kContentCellId"

public class ZXContentView: UIView {
    weak var delegate:ZXContentViewDelegate?
    private var defaultIndex : Int
    private var style:ZXPageStyle
    private var childVcs : [UIViewController]
    private var startOffsetX : CGFloat = 0
    private var didClickTitleView:Bool = false
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.register(UICollectionViewCell.self,forCellWithReuseIdentifier:kContentCellId)
        collectionView.isScrollEnabled = self.style.isScrollEnable
        return collectionView
        
    }()
    
    init(frame:CGRect,childVcs:[UIViewController],style:ZXPageStyle,defaultIndex : Int = 0){
        self.style = style
        self.childVcs = childVcs
        self.defaultIndex = defaultIndex
        super.init(frame: frame)
        setupSubView()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZXContentView{
    fileprivate func setupSubView(){
        //1.添加collectionView
        addSubview(collectionView)
        
        //2.将所有的子控制器添加到父控制器中
        childVcs.forEach { (childVc) in
            if let vc = self.zx_parentViewController{
                vc.addChild(childVc)
            }
        }
        
        //3.先滚动到指定位置
        self.scrollToSpecifiedIndex(self.defaultIndex)
    }
    
    
    
  //最终校准滚动位置
  fileprivate func collectionViewDidEndScroll() {
        //1.获取停止的正确位置
        let inIndex = Int(collectionView.contentOffset.x/collectionView.bounds.width)
        
        //2.通知代理
        delegate?.contentView(self, inIndex: inIndex)
    }
}

extension ZXContentView:UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellId, for: indexPath)
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
   
    
}

extension ZXContentView:UICollectionViewDelegate{
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //1.如果点击了titleView,则不执行以下逻辑
        guard  !didClickTitleView  else { return  }
        
        //2.定于需要的参数
        var progress:CGFloat = 0
        var targetIndex:Int = 0
        var sourceIndex:Int = 0
        
        //3.判断用户是左滑动还是右滑动
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX {//左滑动
            // 1.计算progress  floor:向下取整函数
            progress = currentOffsetX / scrollViewW -  floor(currentOffsetX / scrollViewW)
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            // 4.如果完全划过去
            if progress == 0 {
                progress = 1
                targetIndex = sourceIndex
            }
            
        }else{  //右滑动
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
        //4.通知代理
        delegate?.contentView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        didClickTitleView = false
        startOffsetX = scrollView.contentOffset.x
    }
    
  
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            //如果没有减速的话
            collectionViewDidEndScroll()
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewDidEndScroll()
    }
}


extension ZXContentView:ZXTitleViewDelegate{
    public func titleView(_ titleView: ZXTitleView, nextTitle: String, nextIndex: Int) {
        // 1.点击了titleView
        self.didClickTitleView = true
        // 2.滚动到指定位置
        self.scrollToSpecifiedIndex(nextIndex)
    }
    
    public func scrollToSpecifiedIndex(_ index:Int){
        //1.根据currentIndex获取indexPath
        let indexPath = IndexPath(item: index, section: 0)
        //2.滚动到正确位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
}


