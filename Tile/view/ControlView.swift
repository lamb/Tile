//
//  ControlView.swift
//  Tile
//
//  Created by Lamb on 14-6-19.
//  Copyright (c) 2014年 mynah. All rights reserved.
//

import UIKit

class ControlView{
    
    let defaultFrame = CGRectMake(0, 0, 100, 30)
    
    func createButton(title:String, action:Selector, sender:UIViewController)->UIButton{
        var button = UIButton(frame:defaultFrame)
        button.backgroundColor = UIColor.orangeColor()
        button.setTitle(title, forState:.Normal)
        button.titleLabel.textColor = UIColor.whiteColor()
        button.titleLabel.font = UIFont.systemFontOfSize(14)
        button.addTarget(sender, action:action, forControlEvents:UIControlEvents.TouchUpInside)
        return button
    }
    
    func createTextField(){
    
    }
    
    func createLabel(){
    
    }

}
