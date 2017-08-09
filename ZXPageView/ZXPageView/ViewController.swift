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

        
        let style = ZXPageStyle()
        
        let titles = ["推荐", "游戏", "热门", "趣玩", "娱乐"]
        
        var childVcs = [UIViewController]()
        
        for _ in 0..<titles.count {
            
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green:CGFloat(arc4random_uniform(256))/255.0 , blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
            childVcs.append(vc)
            
        }
        
        
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        let pageView = ZXPageView(frame: pageFrame, style: style, titles: titles, childVcs: childVcs)
        pageView.backgroundColor = UIColor.blue
        view.addSubview(pageView)
        
        
        
        
    
    }

}

