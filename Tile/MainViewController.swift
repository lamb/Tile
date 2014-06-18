//
//  MainViewController.swift
//  Tile
//
//  Created by Lamb on 14-6-18.
//  Copyright (c) 2014年 mynah. All rights reserved.
//

import UIKit;

class MainViewController: UIViewController {
    
    //游戏方格维度
    var dimension:Int = 4
    //游戏过关最大值
    var maxnumber:Int = 2048
    //游戏格子的宽度
    var width:CGFloat = 50
    //格子与格子的间距
    var padding:CGFloat = 6
    //保存背景数据
    var backgrounds:Array<UIView>
    //起始点x
    var fromX:CGFloat = 30
    //起始点y
    var fromY:CGFloat = 90
    
    init(){
        self.backgrounds = Array<UIView>()
        super.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupBackground()
        getNumber()
    }
    
    func setupBackground(){
        var x:CGFloat = fromX
        var y:CGFloat = fromY
        for i in 0..dimension
        {
            y = fromY
            for j in 0..dimension{
                var background = UIView(frame:CGRectMake(x, y, width, width))
                background.backgroundColor = UIColor.darkGrayColor();
                self.view.addSubview(background)
                backgrounds += background
                y += padding + width
            }
            x += padding + width
        }
    }
    
    func getNumber(){
        let randv = Int(arc4random_uniform(10))%2
        println(randv)
        var seed:Int = 2
        if(randv == 1){
            seed = 4;
        }
        let col = Int(arc4random_uniform(UInt32(dimension)))
        let row = Int(arc4random_uniform(UInt32(dimension)))
        println((row, col))
        println(seed)
        insertTile((row, col), value:seed)
    }
    
    func insertTile(pos:(Int, Int), value:Int){
        let (row, col) = pos;
        let x = fromX + CGFloat(col) * (width + padding)
        let y = fromY + CGFloat(row) * (width + padding)
        let tile = TileView(pos:CGPointMake(x, y), width:width, value:value)
        self.view.addSubview(tile)
        self.view.bringSubviewToFront(tile)
        tile.layer.setAffineTransform(CGAffineTransformMakeScale(0.1, 0.1))
        UIView.animateWithDuration(1, delay:0.5, options:UIViewAnimationOptions.TransitionNone, animations:
        {
            ()-> Void in tile.layer.setAffineTransform(CGAffineTransformMakeScale(1, 1))
        },
        completion:{
            (finished:Bool) -> Void in
            UIView.animateWithDuration(0.08, animations:{
                ()-> Void in
                tile.layer.setAffineTransform(CGAffineTransformIdentity)
            })
        })
    }
    
}
