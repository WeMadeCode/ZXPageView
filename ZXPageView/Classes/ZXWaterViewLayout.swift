//
//  ZXPageViewLayout.swift
//  Pods-ZXPageView_Example
//
//  Created by Anthony on 2019/3/15.
//

import UIKit

import UIKit

public protocol ZXWaterViewLayoutDataSource : class {
    func waterView(_ layout: ZXWaterViewLayout, heightForRowAt indexPath: IndexPath) -> CGFloat
}

public class ZXWaterViewLayout: UICollectionViewFlowLayout {
    /// 数据源
    public weak var dataSource : ZXWaterViewLayoutDataSource?
    /// 列数
    public var cols = 2
    private lazy var attrsArray  = [UICollectionViewLayoutAttributes]()
    private var maxH : CGFloat = 0
    private var startIndex = 0
    private lazy var colHeights : [CGFloat] = {
        var colHeights = Array(repeating: self.sectionInset.top, count: self.cols)
        return colHeights
    }()
}


extension ZXWaterViewLayout {
    //MARK: - 初始化生成每个视图的布局信息
    override public func prepare() {
        super.prepare()
        
        // 1.对collectionView进行判空校验
        guard let collectionView = collectionView else { return }
        
        // 2.获取item的个数(仅考虑一个section的情况)
        let itemCount = collectionView.numberOfItems(inSection: 0)
        
        // 3.计算item的宽度
        let itemW = (collectionView.bounds.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing * CGFloat((cols - 1))) / CGFloat(cols)
        
        // 3.计算所有的item的属性
        for itemIndex in startIndex..<itemCount {
            // 3.1设置每一个item位置相关的属性
            let indexPath = IndexPath(item: itemIndex, section: 0)
            
            // 3.2根据位置创建Attributes属性
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 3.3获取item的高度
            guard let itemH = dataSource?.waterView(self, heightForRowAt: indexPath) else{
                fatalError("请设置数据源,并且实现对应的数据源方法")
            }
         
            // 3.4取出最小列的位置
            var minH = colHeights.min()!
            let index = colHeights.index(of: minH)!
            minH = minH + itemH + minimumLineSpacing
            colHeights[index] = minH
            
            // 3.5设置item的属性
            let x = self.sectionInset.left + (self.minimumInteritemSpacing + itemW) * CGFloat(index)
            let y =  minH - itemH - self.minimumLineSpacing
            attrs.frame = CGRect(x: x , y: y, width: itemW, height: itemH)
            
            // 3.6添加到数组中
            attrsArray.append(attrs)
        }
        
        // 4.记录最大值
        maxH = colHeights.max()!
        
        // 5.给startIndex重新复制
        startIndex = itemCount
    }
}


// MARK:- 返回决定一段区域所有cell和头尾视图的布局属性
extension ZXWaterViewLayout {
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
}



// MARK:- 设置可滚动的区域
extension ZXWaterViewLayout {
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxH + sectionInset.bottom - minimumLineSpacing)
    }
}
