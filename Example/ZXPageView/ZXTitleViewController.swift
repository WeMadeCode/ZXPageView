//
//  ZXTitleViewController.swift
//  ZXPageView_Example
//
//  Created by 周翔 on 2019/3/26.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ZXPageView

class ZXTitleViewController: UIViewController {

    var titleView : ZXTitleView!
    
    private var scrollView:UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceHorizontal = false
        view.isScrollEnabled = true
        view.bounces = false
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let style = ZXPageStyle()
        style.isScrollEnable = false
        style.isShowCoverView = true
        style.isDivideByScreen = false
        style.isShowBottomLine = false
        style.coverBgColor = UIColor.orange
        style.normalColor =  UIColor.lightGray
        style.selectColor = UIColor.white
        style.coverAlpha = 1
        
        let y1 = UIApplication.shared.statusBarFrame.height
        let y2 = self.navigationController?.navigationBar.frame.size.height ?? 44
        
        let titleFrame = CGRect(x: 0, y: y1 + y2, width: self.view.frame.width, height: 44)
        let array = ["有奖猜车","李老鼠说车","网罗天下事","xxxxx"]
        let titleView = ZXTitleView(frame: titleFrame, style: style, titles: array,defaultIndex:0)
        self.view.addSubview(titleView)
        self.titleView = titleView
        
        
        
        self.scrollView.frame = CGRect(x: 0, y: titleView.frame.maxY, width: self.view.frame.size.width , height: self.view.frame.size.height - titleView.frame.maxY)
        self.view.addSubview(self.scrollView)
        self.scrollView.delegate = self
        self.scrollView.contentSize.width = CGFloat(array.count) * UIScreen.main.bounds.width
        
        
        
        for (index,_)  in array.enumerated(){
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.zx_randomColor
            vc.view.frame.origin.x = CGFloat(index) * self.view.frame.size.width
            vc.view.frame.origin.y = 0
            vc.view.frame.size.width =  UIScreen.main.bounds.width
            vc.view.frame.size.height = self.scrollView.frame.size.height
            self.scrollView.addSubview(vc.view)
            self.addChild(vc)
        }
        

    }
    

   

}

