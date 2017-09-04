//
//  ViewController.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

private let kCollectionViewCellID = "kCollectionViewCellID"


class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        automaticallyAdjustsScrollViewInsets = false
        
        //1.创建所需要的样式
        let style = ZXPageStyle()
        
        //2.获取所有的标题
        let titles = ["推荐", "游戏", "热门", "趣玩"]
        
        //3.创建布局
        let layout = ZXPageViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        layout.lineSpacing = 10
        layout.itemSpacing = 10
        layout.cols = 7
        layout.rows = 3
        

        //3.创建ZXPageView
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: 300)
        let pageView = ZXPageView(frame: pageFrame, style: style, titles: titles,layout:layout)
        pageView.dataSource = self
        pageView.registerCell(UICollectionViewCell.self, identifier: kCollectionViewCellID)
        pageView.backgroundColor = UIColor.orange
        view.addSubview(pageView)
        
    }

}

extension ViewController :ZXPageViewDataSource{
    
    func numberOfSectionInPageView(_ pageView: ZXPageView) -> Int {
        return 4
    }
    
    func pageView(_ pageView: ZXPageView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 20
        } else if section == 1 {
            return 30
        } else if section == 2 {
            return 7
        }
        
        return 13
    }
    
    func pageView(_ pageView: ZXPageView, cellForItemsAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pageView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellID, for: indexPath)
        
        cell.backgroundColor = UIColor.randomColor
        
        return cell
    }
    
}

