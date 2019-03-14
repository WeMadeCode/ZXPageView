//
//  ViewController.swift
//  ZXPageView
//
//  Created by WeMadeCode on 11/06/2018.
//  Copyright (c) 2018 WeMadeCode. All rights reserved.
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

