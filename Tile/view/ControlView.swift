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
        button.titleLabel?.textColor = UIColor.whiteColor()
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        button.addTarget(sender, action:action, forControlEvents:UIControlEvents.TouchUpInside)
        return button
    }
    
    func createSegment(items:[String], action:Selector, sender:UIViewController) -> UISegmentedControl {
        var segment = UISegmentedControl(items:items);
        segment.frame = defaultFrame
        //segment.segmentedControlStyle = UISegmentedControlStyle.Bordered
        segment.momentary = false
        segment.addTarget(sender, action:action, forControlEvents:UIControlEvents.ValueChanged)
        return segment
    }
    
    
    func createTextField(value:String, action:Selector, sender:UITextFieldDelegate) -> UITextField{
        var textField = UITextField(frame:defaultFrame)
        textField.backgroundColor = UIColor.clearColor()
        textField.textColor = UIColor.blackColor()
        textField.text = value
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = sender
        return textField
    }
    
    func createLabel(title:String) -> UILabel
    {
        let label = UILabel()
        label.textColor = UIColor.blackColor();
        label.backgroundColor = UIColor.whiteColor();
        label.text = title;
        label.frame = defaultFrame
        label.font =  UIFont(name: "HelveticaNeue-Bold", size: 16)
        return label
    }
    
    let colorMap = [
        2:UIColor.redColor(),
        4:UIColor.orangeColor(),
        8:UIColor.yellowColor(),
        16:UIColor.greenColor(),
        32:UIColor.brownColor(),
        64:UIColor.blueColor(),
        128:UIColor.purpleColor(),
        256:UIColor.cyanColor(),
        512:UIColor.lightGrayColor(),
        1024:UIColor.magentaColor(),
        2048:UIColor.blackColor()
    ]
    
    func createTileLabel(pos:CGPoint, width:CGFloat, value:Int) -> UILabel
    {
        var numberLabel:UILabel = UILabel(frame:CGRectMake(pos.x , pos.y, width, width))
        numberLabel.textColor = UIColor.whiteColor()
        numberLabel.textAlignment = NSTextAlignment.Center
        numberLabel.minimumScaleFactor = 0.5
        numberLabel.font = UIFont(name:"微软雅黑", size:20)
        numberLabel.text = "\(value)"
        numberLabel.backgroundColor = colorMap[value]
        println(colorMap[value])
        return numberLabel
    }

}
