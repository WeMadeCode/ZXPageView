//
//  ZXPageViewController.swift
//  ZXPageView
//
//  Created by Anthony on 2017/11/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit
import ZXPageView

class ZXPageViewController: ViewController {

    
    let titles = ["头条推荐", "fff", "1", "车模推荐", "趣玩游", "娱乐","热门游戏", "趣玩游", "娱乐", "热门游戏", "趣玩游", "娱乐"]

    
    override func viewDidLoad() {        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let pageFrame = CGRect(x: 0, y: safeY , width: view.bounds.width, height: 500 )
        let pageView = ZXPageView(frame: pageFrame, dataSource: self)
        pageView.backgroundColor = UIColor.red
        pageView.deleagte = self
        self.view.addSubview(pageView)
        
    }


    deinit {
        print("deinit")
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
            
            let view = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
            view.backgroundColor = UIColor.red
            vc.view.addSubview(view)
            
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
