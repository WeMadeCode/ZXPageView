//
//  ViewController.swift
//  ZXPageView
//
//  Created by WeMadeCode on 11/06/2018.
//  Copyright (c) 2018 WeMadeCode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var safeY:CGFloat {
        return (self.navigationController?.navigationBar.frame.size.height ?? 44) + UIApplication.shared.statusBarFrame.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

  
    
    @IBAction func btnClick(_ sender: Any) {
        
        let vc = ZXPageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    @IBAction func btn2Click(_ sender: Any) {
        
        
        let vc = ZXWaterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btn3Click(_ sender: Any) {
        
        let vc = ZXTitleViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

