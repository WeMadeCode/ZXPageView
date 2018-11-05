//
//  ZXNotification+Extension.swift
//  ZXPageView
//
//  Created by Anthony on 2018/11/5.
//  Copyright © 2018 Anthony. All rights reserved.
//

import UIKit


let ntcPrefix = "zxpageview.notification"

extension Notification.Name {
    public struct TitleView {
       public static let sendTag = Notification.Name(rawValue: "\(ntcPrefix).titleView.sendTag")
    }
}

