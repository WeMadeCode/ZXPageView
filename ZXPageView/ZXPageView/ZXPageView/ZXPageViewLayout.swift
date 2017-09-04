//
//  ZXPageViewLayout.swift
//  ZXPageView
//
//  Created by Anthony on 2017/9/4.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

class ZXPageViewLayout: UICollectionViewFlowLayout {
    fileprivate lazy var cellAttrs : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var pageCount = 0
    var sectionInset : UIEdgeInsets = UIEdgeInsets.zero
    var itemSpacing : CGFloat = 0
    var lineSpacing : CGFloat = 0
    var cols = 4
    var rows = 2
}


// MARK: - 准备所有的布局
extension ZXPageViewLayout{
    override func prepare() {
        super.prepare()
        //1.对collectionView进行校验
        guard let collectionView = collectionView else { return }
        
        //2.获得多少组
        let sectionCount = collectionView.numberOfSections
        
        //3.获取每组中有多少个数据
        for sectionIndex in 0..<sectionCount {
            
            let itemCount = collectionView.numberOfItems(inSection: sectionIndex)
            //4.为每一个cell创建对应的UICollectionViewLayoutAttributes
            for itemIndex in 0..<itemCount {
                //4.1创建Attributes
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                //4.2设置Attributes的frame
                let itemW : CGFloat = 100
                let itemH : CGFloat = 100
                let itemX : CGFloat = 10
                let itemY : CGFloat = 10
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                
                // 4.3将Attributes添加到数组中
                cellAttrs.append(attr)
            }
            
            
        }
        
    }
    
}


// MARK: - 返回所有的布局
extension ZXPageViewLayout{
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
    
}


// MARK: - 设置可滚动区域
extension ZXPageViewLayout{
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: 10000, height: 0)
    }
}
