//
//  ZXPageViewController.swift
//  ZXPageView
//
//  Created by Anthony on 2017/11/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit
import ZXPageView
import SnapKit

class ZXPageViewController: ViewController {

    
    let titles = ["头条推荐", "fff", "1", "车模推荐", "趣玩游", "娱乐","热门游戏", "趣玩游", "娱乐", "热门游戏", "趣玩游", "娱乐"]

    
    override func viewDidLoad() {        
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor.white
        
        self.autoLayout()
     
    
    }

    
    func frameLayout(){
        let pageFrame = CGRect(x: 0, y: safeY , width: view.bounds.width, height: 500 )
        let pageView = ZXPageView(frame: pageFrame)
        pageView.delegate = self
        pageView.dataSource = self
        self.view.addSubview(pageView)
        
    }
    
    
    /*
     需要解决的问题：
     1.defaultPageSize必须设置，否则会出问题
     2.pageView或者其他依赖的布局的空间 updateConstraints会出问题。

    */
    func autoLayout(){
        let pageView = ZXPageView()
        self.view.addSubview(pageView)
        pageView.delegate = self
        pageView.dataSource = self
        pageView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *){
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            }else{
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print(self.children)
        
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
   
    func defaultPageSize() -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 300)
    }
    
    func defaultScrollIndex() -> Int {
        return 4
    }
   
    func titlesForPageView() -> [String]{
        return self.titles        
    }
    func contentForPageView() -> [UIViewController]{
        var childVcs = [TestViewController]()
        for i in 0..<titles.count {
            let vc = TestViewController()
            if i == 4{
                vc.view.backgroundColor = UIColor.red
            }else{
                vc.view.backgroundColor = UIColor.random
            }
            childVcs.append(vc)
            self.addChild(vc)
        }
        return childVcs
    }
    
    func styleForPageView() -> ZXPageStyle{
        let style = ZXPageStyle()
//        style.isShowEachView = true
//        style.isShowCoverView = true
        style.isDivideByScreen = false
        style.isShowBottomLine = true
//        style.coverBgColor = UIColor.lightGray
        style.normalColor = UIColor.lightGray
        style.selectColor = UIColor.red
        style.coverAlpha = 1
        return style
    }
    
    
}
