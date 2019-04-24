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
    private var maxHeight : CGFloat = 0
    // 所有列的总高度
    private lazy var colHeights = [CGFloat]()
}


extension ZXWaterViewLayout {
    //MARK: - 初始化生成每个视图的布局信息
    override public func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        
        //高度高度数组
        colHeights = Array(repeating: self.sectionInset.top, count: self.cols)
        
        //清除布局信息
        attrsArray.removeAll()
        
        //获取行数(仅考虑一个section的情况)
        let rowCount = collectionView.numberOfItems(inSection: 0)
       
        for row in 0..<rowCount{
            //创建位置
            let indexPath = IndexPath(item: row, section: 0)
            
            //计算indexPath位置cell对应的布局属性
            if let attrs = self.layoutAttributesForItem(at: indexPath){
                attrsArray.append(attrs)
            }
        }
    }
    
    // MARK:- 返回决定一段区域所有cell和头尾视图的布局属性
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    // MARK:- 设置可滚动的区域
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxHeight + sectionInset.bottom - minimumLineSpacing)
    }
    
    // MARK:- 返回indexPath位置cell对应的布局属性
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        
        //创建布局属性
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
 
        //计算宽度
        let itemW = (collectionView.bounds.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing * CGFloat((cols - 1))) / CGFloat(cols)
        
        //获取高度
        guard let itemH = dataSource?.waterView(self, heightForRowAt: indexPath) else{
            fatalError("请设置数据源,并且实现对应的数据源方法")
        }
        
        // 取出最小列的值
        guard var minH = colHeights.min() else { return nil }
        guard let index = colHeights.index(of: minH) else { return nil}
        minH = minH + itemH + minimumLineSpacing
        // 更新最短那列的高度
        colHeights[index] = minH
        
        // 记录最大高度
        if maxHeight < minH{
            maxHeight = minH
        }
        
        //计算横坐标
        let itemX = self.sectionInset.left + (self.minimumInteritemSpacing + itemW) * CGFloat(index)
        //计算纵坐标
        let itemY =  minH - itemH - self.minimumLineSpacing
        
        attrs.frame = CGRect(x: itemX , y: itemY, width: itemW, height: itemH)

        return attrs
    }
    
}


