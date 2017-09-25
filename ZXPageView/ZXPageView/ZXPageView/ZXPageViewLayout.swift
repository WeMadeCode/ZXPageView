//
//  ZXPageViewLayout.swift
//  ZXPageView
//
//  Created by Anthony on 2017/9/4.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

class ZXPageViewLayout: UICollectionViewLayout {
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
        let itemW : CGFloat = (collectionView.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * itemSpacing)/CGFloat(cols)
        let itemH : CGFloat = (collectionView.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat(rows - 1) * lineSpacing)/CGFloat(rows)
        //计算累加的组有多少页
        for sectionIndex in 0..<sectionCount {
            
            let itemCount = collectionView.numberOfItems(inSection: sectionIndex)
            
            //4.为每一个cell创建对应的UICollectionViewLayoutAttributes
            for itemIndex in 0..<itemCount {
                //4.1创建Attributes
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                //4.2求出itemIndex在该组中的第几页中的第几个
                let pageIndex = itemIndex/(rows * cols)
                let pageItemIndex = itemIndex % (rows * cols)
                
                //4.3求itemIndex在该页中第几行/第几列
                let rowIndex = pageItemIndex / cols
                let colIndex = pageItemIndex % cols
                
                //4.4设置Attributes的frame
                let itemX : CGFloat = CGFloat(pageCount + pageIndex) * collectionView.bounds.width + sectionInset.left + (itemW + itemSpacing) * CGFloat(colIndex)
                let itemY : CGFloat = sectionInset.top + (itemH + lineSpacing) * CGFloat(rowIndex)
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                
                // 4.5将Attributes添加到数组中
                cellAttrs.append(attr)
            }
            
            //5.计算该组一共占据多少页
            pageCount += (itemCount - 1) / (cols * rows) + 1

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
        return CGSize(width: CGFloat(pageCount) * collectionView!.bounds.width, height: 0)
    }
}
