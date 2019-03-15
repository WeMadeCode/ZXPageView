//
//  ZXWaterViewController.swift
//  ZXPageView_Example
//
//  Created by Anthony on 2019/3/15.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ZXPageView


private let kCollectionViewCellID = "kCollectionViewCellID"

class ZXWaterViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor.white
        
        // 1.创建需要的样式
        let style = ZXPageStyle()
        style.isLongStyle = false

        // 2.获取所有的标题
        let titles = ["推荐", "游戏游戏游戏游戏", "热门"] //, "趣玩"
        
        // 3.创建布局
        let layout = ZXWaterViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.lineSpacing = 10
        layout.itemSpacing = 10
        layout.cols = 4
        layout.rows = 2
        
        // 4.创建Water
        let pageFrame = CGRect(x: 0, y: self.safeY, width: self.view.bounds.width, height: 300)
        let pageView = ZXWaterView(frame: pageFrame, style: style, titles: titles, layout : layout)
        pageView.dataSource = self
        pageView.delegate = self
        pageView.registerCell(UICollectionViewCell.self, identifier: kCollectionViewCellID)
        pageView.backgroundColor = UIColor.orange
        view.addSubview(pageView)
    }
    
    deinit {
        print("deinit")

    }


}


extension ZXWaterViewController : ZXWaterViewDataSource {
    func numberOfSectionsInWaterView(_ waterView: ZXWaterView) -> Int {
        return 3
    }
    
    func waterView(_ waterView: ZXWaterView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 12
        } else if section == 1 {
            return 30
        } else if section == 2 {
            return 7
        }else{
            return 13
        }
        
       
    }
    
    func waterView(_ waterView: ZXWaterView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = waterView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor
        return cell
    }
}


extension ZXWaterViewController : ZXWaterViewDelegate {
    func waterView(_ waterView: ZXWaterView, didSelectedAtIndexPath indexPath: IndexPath) {
        print(indexPath)
    }
}










