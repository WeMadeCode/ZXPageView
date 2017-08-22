//
//  ViewController.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        automaticallyAdjustsScrollViewInsets = false
        
        //1.创建所需要的样式
        let style = ZXPageStyle()
        style.isScrollEnable = true
        style.isShowBottomLine = true
        style.isScaleEnable = true
        //2.获取所有的标题
        let titles = ["推荐", "游戏游戏游戏", "热门游戏", "趣玩游", "娱乐", "热门游戏", "趣玩游", "娱乐"]
        
        
        //3.获取所有的内容控制器
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor
            childVcs.append(vc)
            
        }
        
        //4.创建ZXPageView
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        let pageView = ZXPageView(frame: pageFrame, style: style, titles: titles, childVcs: childVcs,parentVc:self)
        pageView.backgroundColor = UIColor.blue
        view.addSubview(pageView)
        
        
    }

}

