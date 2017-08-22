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

class ZXContentView: UIView {

    
    // MARK: 定义属性
    weak var delegate:ZXContentViewDelegate?
    
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var isForbidDelegate:Bool = false
    fileprivate lazy var collectionView:UICollectionView = {
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
        return collectionView
        
    }()
    
    // MARK: 构造函数
    init(frame:CGRect,childVcs:[UIViewController],parentVc:UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        setupSubView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZXContentView{
    fileprivate func setupSubView(){
        //1.添加collectionView
        addSubview(collectionView)
        
        //2.将所有的子控制器添加到父控制器中
        for childVc in childVcs {
            parentVc.addChildViewController(childVc)
        }
    
    }
}

extension ZXContentView:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellId, for: indexPath)
        
        //2.给cell设置内容
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
        
        
    }
    

}

extension ZXContentView:UICollectionViewDelegate{

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {//如果没有减速的话
            collectionViewDidEndScroll()
        }
    }
    
    func collectionViewDidEndScroll() {
        //1.获取位置
        let inIndex = Int(collectionView.contentOffset.x/collectionView.bounds.width)
        
        //2.通知代理
        delegate?.contentView(self, inIndex: inIndex)
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //1.判断是否需要执行后续代码
        if scrollView.contentOffset.x == startOffsetX || isForbidDelegate {
            return
        }
        
        //2.定于需要的参数
        var progress:CGFloat = 0
        var targetIndex = 0
        let sourceIndex = Int(startOffsetX/collectionView.bounds.width)
        
        //3.判断用户是左滑动还是右滑动
        if collectionView.contentOffset.x > startOffsetX {//左滑动
            targetIndex = sourceIndex + 1
            progress = (collectionView.contentOffset.x - startOffsetX)/collectionView.bounds.width
            
        }else{  //右滑动
            targetIndex = sourceIndex - 1
            progress = (startOffsetX - collectionView.contentOffset.x)/collectionView.bounds.width
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


