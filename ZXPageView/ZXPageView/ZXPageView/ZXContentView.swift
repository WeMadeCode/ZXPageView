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
    private var style:ZXPageStyle
    private var childVcs : [UIViewController]
    private weak var  parentVc : UIViewController!
    private var startOffsetX : CGFloat = 0
    private var isForbidDelegate:Bool = false
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
        
        collectionView.isScrollEnabled = self.style.contentScrollEnable
        return collectionView
        
    }()
    
    init(frame:CGRect,childVcs:[UIViewController],parentVc:UIViewController,style:ZXPageStyle) {
        self.style = style
        self.childVcs = childVcs
        self.parentVc = parentVc
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
            self.parentVc.addChildViewController(childVc)
        }
    }
}

extension ZXContentView:UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellId, for: indexPath)
        //2.给cell设置内容
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        //3.返回cell
        return cell
    }
    

}

extension ZXContentView:UICollectionViewDelegate{

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewDidEndScroll()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {//如果没有减速的话
            collectionViewDidEndScroll()
        }
    }
    
    func collectionViewDidEndScroll() {
        //1.获取停止的正确位置
        let inIndex = Int(collectionView.contentOffset.x/collectionView.bounds.width)
        
        //2.通知代理
        delegate?.contentView(self, inIndex: inIndex)
        
    }
    
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //1.判断是否需要执行后续代码
        guard  !isForbidDelegate  else { return  }
        
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

}


extension ZXContentView:ZXTitleViewDelegate{
    
    func titleView(_ titleView: ZXTitleView, currentIndex: Int) {
        
        // 0.设置isForbidDelegate属性为true
        isForbidDelegate = true
        
        //1.根据currentIndex获取indexPath
        let indexPath = IndexPath(item: currentIndex, section: 0)
        //2.滚动到正确位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
    }

}


