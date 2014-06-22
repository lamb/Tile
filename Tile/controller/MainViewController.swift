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
    //游戏数据模型
    var gmodel:GameModel
    //保存界面上的数字Label数据
    var tiles:Dictionary<NSIndexPath, TileView>
    //保存实际数字值的一个字典
    var tileVals:Dictionary<NSIndexPath, Int>
    
    init(){
        self.backgrounds = Array<UIView>()
        self.gmodel = GameModel(dimension:self.dimension)
        self.tiles = Dictionary<NSIndexPath, TileView>()
        self.tileVals = Dictionary<NSIndexPath, Int>()
        super.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupBackground()
        setButtons()
        setupSwipeGestures()
        for i in 0..16{
            genNumber()
        }
    }
    
    func setButtons(){
        var cv = ControlView()
        var resetButton = cv.createButton("重置", action:Selector("resetTapped"), sender:self)
        resetButton.frame.origin.x = 50
        resetButton.frame.origin.y = 350
        self.view.addSubview(resetButton)
    
        var genButton = cv.createButton("新数", action:Selector("genTapped"), sender:self)
        genButton.frame.origin.x = 150
        genButton.frame.origin.y = 350
        self.view.addSubview(genButton)
    }
    
    func resetTapped(){
        println("重置")
        resetUI()
        gmodel.initTiles();
    }
    
    func resetUI(){
        for(key, tile) in tiles{
            tile.removeFromSuperview()
        }
        tiles.removeAll(keepCapacity: true)
        tileVals.removeAll(keepCapacity: true)
    }
    
    func initUI(){
        for i in 0..dimension{
            for j in 0..dimension{
                var index = i * self.dimension + j
                if(gmodel.tiles[index] != 0){
                    insertTile((i,j), value:gmodel.tiles[index])
                }
            }
        }
    }
    
    func genTapped(){
        println("新数")
        genNumber()
    }
    
    func setupSwipeGestures(){
        let upSwipe = UISwipeGestureRecognizer(target:self, action:Selector("swipeUp"))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(upSwipe)
        let downSwipe = UISwipeGestureRecognizer(target:self, action:Selector("swipeDown"))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(downSwipe)
        let leftSwipe = UISwipeGestureRecognizer(target:self, action:Selector("swipeLeft"))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target:self, action:Selector("swipeRight"))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    func printTiles(tiles:Array<Int>){
        var count = tiles.count
        for(var i = 0;i < count;i++){
            if(i + 1)%dimension == 0{
                println(tiles[i])
            }else{
                print("\(tiles[i])\t")
            }
        }
        println("")
    
    }
    
    func swipeUp(){
        println("swipeUp")
        gmodel.reflowUp()
        gmodel.mergeUp()
        gmodel.reflowUp()
        resetUI()
        initUI()
//        for i in 0..dimension{
//            for j in 0..dimension{
//                var row:Int = i
//                var col:Int = j
//                var key = NSIndexPath(forRow:row, inSection:col)
//                if(tileVals.indexForKey(key) != nil){
//                    if(row > 0){
//                        var value = tileVals[key];
//                        removeKeyTile(key)
//                        var index = row * dimension + col - dimension
//                        row = Int (index/dimension)
//                        col = index - row * dimension
//                        insertTile((row,col), value:value!)
//                    }
//                }
//            }
//        }
    }
    func swipeDown(){
        println("swipeDown")
        gmodel.reflowDown()
        gmodel.mergeDown()
        gmodel.reflowDown()
        resetUI()
        initUI()
    }
    func swipeLeft(){
        println("swipeLeft")
        gmodel.reflowLeft()
        gmodel.mergeLeft()
        gmodel.reflowLeft()
        resetUI()
        initUI()
    }
    func swipeRight(){
        println("swipeRight")
        gmodel.reflowRight()
        gmodel.mergeRight()
        gmodel.reflowRight()
        resetUI()
        initUI()
    }
    
    func removeKeyTile(key:NSIndexPath){
        var tile = tiles[key]!
        var tileVal = tileVals[key]
        
        tile.removeFromSuperview()
        tiles.removeValueForKey(key)
        tileVals.removeValueForKey(key)
    
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
    
    func genNumber(){
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
        if(gmodel.isFull()){
            println("该位置已经有值了")
            return
        }
        if(gmodel.setPosition(row, col:col, value:seed) == false){
            genNumber()
            return
        }
        insertTile((row, col), value:seed)
    }
    
    func insertTile(pos:(Int, Int), value:Int){
        let (row, col) = pos;
        let x = fromX + CGFloat(col) * (width + padding)
        let y = fromY + CGFloat(row) * (width + padding)
        let tile = TileView(pos:CGPointMake(x, y), width:width, value:value)
        self.view.addSubview(tile)
        self.view.bringSubviewToFront(tile)
        var index = NSIndexPath(forRow:row, inSection:col)
        tiles[index]=tile;
        tileVals[index]=value;
        tile.layer.setAffineTransform(CGAffineTransformMakeScale(0.1, 0.1))
        UIView.animateWithDuration(0.3, delay:0.1, options:UIViewAnimationOptions.TransitionNone, animations:
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
