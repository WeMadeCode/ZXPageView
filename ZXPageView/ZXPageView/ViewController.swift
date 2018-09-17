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

    
    
    }
    

    
    @IBAction func btnClick(_ sender: Any) {
        
        let vc = ZXPageViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    

}



