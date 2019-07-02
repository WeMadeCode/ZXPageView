//
//  ZXTitleViewController.swift
//  ZXPageView_Example
//
//  Created by Anthony on 2019/7/2.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ZXPageView

class ZXTitleViewController: UIViewController {

    var titleView : ZXTitleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        
        let titles = ["头条推荐", "fff", "1", "车模推荐", "趣玩游", "娱乐","热门游戏", "趣玩游", "娱乐", "热门游戏", "趣玩游", "娱乐"]

        
        let style = ZXPageStyle()
        style.isShowEachView = true
        style.isDivideByScreen = false
        style.isShowBottomLine = false
        style.coverBgColor = UIColor.lightGray
        style.normalColor = UIColor.lightGray
        style.selectColor = UIColor.white
        style.coverAlpha = 1
        
        titleView = ZXTitleView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 50), style: style, titles: titles)
        
        self.view.addSubview(titleView)
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleView.updateTitles(["趣玩游", "娱乐", "热门游戏", "趣玩游", "娱乐","头条推荐", "fff", "1", "车模推荐", "趣玩游", "娱乐","热门游戏", "趣玩游", "娱乐", "热门游戏", "趣玩游", "娱乐"])
    }
    

}
