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


class ZXPageViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.method2()
        
    }


    deinit {
        print("deinit")
        
        NotificationCenter.default.removeObserver(self)
    }
}



extension ZXPageViewController{
    
    //用法1
    func method1(){
        
        // 1.创建需要的样式
        let style = ZXPageStyle()
//        style.isScrollEnable = false
        style.isShowCoverView = true
        style.isShowBottomLine = false
        style.coverBgColor = UIColor.orange
        style.selectColor = UIColor.white
        style.coverAlpha = 1
        style.divideScreen = false
        // 2.获取所有的标题
         let titles = ["头条推荐", "fff", "1", "车模推荐", "趣玩游", "娱乐","热门游戏", "趣玩游", "娱乐", "热门游戏", "趣玩游", "娱乐"]
        
        // 3.获取所有的内容控制器
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor
            childVcs.append(vc)
        }
        // 4.创建HYPageView
        let y1 = UIApplication.shared.statusBarFrame.height
        let y2 = self.navigationController?.navigationBar.frame.size.height ?? 44
        let pageFrame = CGRect(x: 0, y: y1 + y2 , width: view.bounds.width, height: view.bounds.height - y1 - y2)
        let pageView = ZXPageView(frame: pageFrame, style: style, titles: titles, childVcs: childVcs, parentVc : self, defaultIndex : 10)
        view.addSubview(pageView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(_:)), name: NSNotification.Name.TitleView.sendTag, object: nil)
    }
    
    
    @objc func getMessage(_ noti:Notification){
        
        if  let objc = noti.object as? Int{
            print(objc)
        }
        
       
        
    }
    //用法2
    func method2(){
        //1.创建所需要的样式
        let style = ZXPageStyle()
        //2.获取所有的标题
        let titles = ["推荐", "游戏", "热门", "趣玩"]
        //3.创建布局
        let layout = ZXPageViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        layout.lineSpacing = 10
        layout.itemSpacing = 10
        layout.cols = 4
        layout.rows = 2
        //3.创建ZXPageView
        let y1 = UIApplication.shared.statusBarFrame.height
        let y2 = self.navigationController?.navigationBar.frame.size.height ?? 44
        let pageFrame = CGRect(x: 0, y: y1 + y2, width: view.bounds.width, height: 300)
        let pageView = ZXPageView(frame: pageFrame, style: style, titles: titles,layout:layout)
        pageView.dataSource = self
        pageView.delegate = self
        pageView.registerCell(UICollectionViewCell.self, identifier: kCollectionViewCellID)
        pageView.backgroundColor = UIColor.white
        view.addSubview(pageView)
    }
    
    
    
    func method3(){
        
        let titleArray = ["头条推荐", "fff", "1", "车模推荐", "趣玩游", "娱乐","热门游戏", "趣玩游", "娱乐", "热门游戏", "趣玩游", "娱乐"]
        
        let style = ZXPageStyle()
        style.isScrollEnable = false
        style.isShowCoverView = true
        style.divideScreen = false
        style.isShowBottomLine = false
        style.coverAlpha = 1
        
        let y = UIApplication.shared.statusBarFrame.height + 44
        
        let titleFrame = CGRect(x: 0, y: y, width: self.view.frame.width, height: 44)
        let titleView = ZXTitleView(frame: titleFrame, style: style, titles: titleArray,defaultIndex:10000)
        self.view.backgroundColor = UIColor.lightGray
        self.view.addSubview(titleView)
    }
}

extension ZXPageViewController :ZXPageViewDataSource{
    
    //有多少组
    func numberOfSectionInPageView(_ pageView: ZXPageView) -> Int {
        return 4
    }
    
    //每组有多少个
    func pageView(_ pageView: ZXPageView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 12
        } else if section == 1 {
            return 30
        } else if section == 2 {
            return 7
        }
        
        return 13
    }
    
    //每组的具体内容
    func pageView(_ pageView: ZXPageView, cellForItemsAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pageView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor
        return cell
    }
}

extension ZXPageViewController:ZXPageViewDelegate{
    //点击某个item
    func pageView(_ pageView: ZXPageView, didSelectedAtIndexPath indexPath: IndexPath) {
        print(indexPath)
    }
    
}

