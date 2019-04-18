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

class ZXHorizontalViewController: ViewController {

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
        let layout = ZXHorizontalViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.lineSpacing = 10
        layout.itemSpacing = 10
        layout.cols = 4
        layout.rows = 2
        
        // 4.创建Water
        let pageFrame = CGRect(x: 0, y: self.safeY, width: self.view.bounds.width, height: 300)
        let pageView = ZXHorizontalView(frame: pageFrame, style: style, titles: titles, layout : layout)
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


extension ZXHorizontalViewController : ZXHorizontalViewDataSource {
    func numberOfSectionsInWaterView(_ waterView: ZXHorizontalView) -> Int {
        return 3
    }

    func waterView(_ waterView: ZXHorizontalView, numberOfItemsInSection section: Int) -> Int {
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

    func waterView(_ waterView: ZXHorizontalView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = waterView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellID, for: indexPath)
        cell.backgroundColor = UIColor.zx_randomColor
        return cell
    }
}


extension ZXHorizontalViewController : ZXHorizontalViewDelegate {
    func waterView(_ waterView: ZXHorizontalView, didSelectedAtIndexPath indexPath: IndexPath) {
        print(indexPath)
    }
}










