//
//  TabViewController.swift
//  Tile
//
//  Created by Lamb on 14-6-18.
//  Copyright (c) 2014年 mynah. All rights reserved.
//

import UIKit;

class TabViewController: UITabBarController {
    
    init(){
        super.init(nibName:nil, bundle:nil)
        var viewMain = MainViewController();
        viewMain.title = "2048"
        var viewSetting = SettingViewController()
        viewSetting.title = "设置"
        var main = UINavigationController(rootViewController:viewMain)
        var setting = UINavigationController(rootViewController:viewSetting)
        self.viewControllers = [main, setting]
        //self.selectedIndex = 0;
    }
    
}
