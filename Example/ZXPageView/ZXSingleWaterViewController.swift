//
//  ZXSingleWaterViewController.swift
//  ZXPageView_Example
//
//  Created by 周翔 on 2019/4/18.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ZXPageView



private let kWaterCellID = "kWaterCellID"

class ZXSingleWaterViewController: UIViewController {
    
    var count : Int = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 1.设置布局
        let layout = ZXWaterViewLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.dataSource = self
        
        // 2.创建UICollectionView
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kWaterCellID)
        view.addSubview(collectionView)
    }
    
    
    deinit {
        print("deinit")
        
    }
    
}

extension ZXSingleWaterViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWaterCellID, for: indexPath)
        
        cell.backgroundColor = UIColor.zx_randomColor
        
//        if indexPath.item == count - 1 {
//            count += 20
//
//            collectionView.reloadData()
//        }
        
        return cell
    }
}


extension ZXSingleWaterViewController : ZXWaterViewLayoutDataSource {
    func waterView(_ layout: ZXWaterViewLayout, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return CGFloat(arc4random_uniform(80) + 100)
    }
    
    
    
}
