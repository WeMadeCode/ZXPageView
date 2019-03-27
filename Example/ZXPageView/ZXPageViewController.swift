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

    
    let titles = ["头条推荐", "fff", "1", "车模推荐", "趣玩游", "娱乐","热门游戏", "趣玩游", "娱乐", "热门游戏", "趣玩游", "娱乐"]

    
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
        
        let pageFrame = CGRect(x: 0, y: safeY , width: view.bounds.width, height: view.bounds.height - safeY )
        let pageView = ZXPageView(frame: pageFrame, dataSource: self)
        pageView.backgroundColor = UIColor.red
        pageView.deleagte = self
        self.view.addSubview(pageView)
    }

    
    
    func method2(){
        
//        let titleArray = ["头条推荐", "fff", "1", "车模推荐", "趣玩游", "娱乐","热门游戏", "趣玩游", "娱乐", "热门游戏", "趣玩游", "娱乐"]
//        
//        let style = ZXPageStyle()
//        style.isScrollEnable = false
//        style.isShowCoverView = true
//        style.divideScreen = false
//        style.isShowBottomLine = false
//        style.coverAlpha = 1
//        
//        let y =
//        
//        let titleFrame = CGRect(x: 0, y: y, width: self.view.frame.width, height: 44)
//        let titleView = ZXTitleView(frame: titleFrame, style: style, titles: titleArray,defaultIndex:10000)
//        self.view.backgroundColor = UIColor.lightGray
//        self.view.addSubview(titleView)
        
    }
}


extension ZXPageViewController:ZXPageViewDelegate{
    func pageView(_ pageView:ZXPageView,currentTitle:String,currentIndex:Int){
        debugPrint(#function)
    }
    func pageView(_ pageView:ZXPageView,nextTitle:String,nextIndex:Int){
        debugPrint(#function)
    }
}


extension ZXPageViewController:ZXPageViewDataSource{
   
   
    func titlesForPageView() -> [String]{
        return self.titles        
    }
    func contentForPageView() -> [UIViewController]{
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.zx_randomColor
            childVcs.append(vc)
        }
        return childVcs
    }
    
    func styleForPageView() -> ZXPageStyle{
        let style = ZXPageStyle()
        style.isShowCoverView = true
        style.isDivideByScreen = false
        style.isShowBottomLine = false
        style.coverBgColor = UIColor.orange
        style.normalColor = UIColor.lightGray
        style.selectColor = UIColor.white
        style.coverAlpha = 1
        return style
    }
    
    
}
