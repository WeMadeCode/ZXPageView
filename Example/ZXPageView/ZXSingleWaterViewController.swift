//
//  ZXSingleWaterViewController.swift
//  ZXPageView_Example
//
//  Created by 周翔 on 2019/4/18.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ZXPageView
import MJRefresh



private let kWaterCellID = "kWaterCellID"

class ZXSingleWaterViewController: UIViewController {
    
    var count : Int = 1
    
    lazy var collectionView: UICollectionView = {
        let layout = ZXWaterViewLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kWaterCellID)
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewData))
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
     
        view.addSubview(collectionView)
    }
    
    @objc func loadMoreData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.collectionView.mj_footer.endRefreshing()
            self.count += 1
            self.collectionView.reloadData()
            
        }
    }
    
    @objc func loadNewData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.collectionView.mj_header.endRefreshing()
            self.count = 1
            self.collectionView.reloadData()
            
        }
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
    
        return cell
    }
}


extension ZXSingleWaterViewController : ZXWaterViewLayoutDataSource {
    func waterView(_ layout: ZXWaterViewLayout, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return CGFloat(arc4random_uniform(80) + 100)
    }
    
    
    
}
