//
//  ZXPageViewController.swift
//  ZXPageView
//
//  Created by Anthony on 2017/11/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit
import ZXPageView

private let kCollectionViewCellID = "kCollectionViewCellID"


class ZXPageViewController: ViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.method1()
        
    }


    deinit {
        print("deinit")
        
    }
}



extension ZXPageViewController{
    
    //用法1
    func method1(){
        
        // 1.创建需要的样式
        let style = ZXPageStyle()
        style.isLongStyle = false
//        style.isShowCoverView = true
//        style.isShowBottomLine = true
//        style.coverBgColor = UIColor.orange
//        style.selectColor = UIColor.white
//        style.coverAlpha = 1
//        style.divideScreen = false
        // 2.获取所有的标题
         let titles = ["头条推荐", "fff", "1", "车模推荐", "趣玩游", "娱乐","热门游戏", "趣玩游", "娱乐", "热门游戏", "趣玩游", "娱乐"]
        // 3.获取所有的内容控制器
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor
            childVcs.append(vc)
        }
        // 4.创建ZXPageView
        let y1 = UIApplication.shared.statusBarFrame.height
        let y2 = self.navigationController?.navigationBar.frame.size.height ?? 44 //y1 + y2
        let pageFrame = CGRect(x: 0, y: 0 , width: view.bounds.width, height: view.bounds.height - 100 ) //- y1 - y2
        let pageView = ZXPageView(frame: pageFrame, style: style, titles: titles, childVcs: childVcs, parentVc : self, defaultIndex : 2)
        pageView.didFinishedScrollHandle = { title , index in
            print(title,index)
        }
        pageView.backgroundColor = UIColor.red
        view.addSubview(pageView)

    }

    
    
    func method2(){
        
        let titleArray = ["头条推荐", "fff", "1", "车模推荐", "趣玩游", "娱乐","热门游戏", "趣玩游", "娱乐", "热门游戏", "趣玩游", "娱乐"]
        
        let style = ZXPageStyle()
//        style.isScrollEnable = false
//        style.isShowCoverView = true
//        style.divideScreen = false
//        style.isShowBottomLine = false
//        style.coverAlpha = 1
        
        let y = UIApplication.shared.statusBarFrame.height + 44
        
        let titleFrame = CGRect(x: 0, y: y, width: self.view.frame.width, height: 44)
        let titleView = ZXTitleView(frame: titleFrame, style: style, titles: titleArray,defaultIndex:10000)
        self.view.backgroundColor = UIColor.lightGray
        self.view.addSubview(titleView)
        
    }
}

