//
//  MainViewController.swift
//  Tile
//
//  Created by Lamb on 14-6-18.
//  Copyright (c) 2014年 mynah. All rights reserved.
//

import UIKit;

enum Animation2048Type{
    case None   //无动画
    case New    //新出现动画
    case Merge  //合并动画
}

class MainViewController: UIViewController {
    
    //游戏方格维度
    var dimension:Int = 4
    //游戏过关最大值
    var maxnumber:Int = 32
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
    var gmodel:GameModel!
    //保存界面上的数字Label数据
    var tiles:Dictionary<NSIndexPath, TileView>
    //保存实际数字值的一个字典
    var tileVals:Dictionary<NSIndexPath, Int>
    var score:ScoreView!
    var bestScore:BestScoreView!
    
    init(){
        self.backgrounds = Array<UIView>()
        self.tiles = Dictionary<NSIndexPath, TileView>()
        self.tileVals = Dictionary<NSIndexPath, Int>()
        super.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupBackground()
        setButtons()
        setScoreLable()
        setupSwipeGestures()
        self.gmodel = GameModel(dimension:self.dimension,scoreDelegate:score,bestScoreDelegate:bestScore)
        for i in 0..2{
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
    
    func setScoreLable(){
        score = ScoreView()
        score.frame.origin.x = 50
        score.frame.origin.y = 400
        score.changeScore(value:0)
        self.view.addSubview(score)
        
        bestScore = BestScoreView()
        bestScore.frame.origin.x = 170
        bestScore.frame.origin.y = 400
        bestScore.changeScore(value:0)
        self.view.addSubview(bestScore)
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
        score.changeScore(value:0)
        gmodel.score = 0
    }
    
    func initUI(){
        var index:Int
        var key:NSIndexPath
        var tile:TileView
        var tileVal:Int
        var success:Bool = false
        for i in 0..dimension{
            for j in 0..dimension{
                index = i * self.dimension + j
                key = NSIndexPath(forRow:i, inSection:j)
                if(gmodel.tiles[index]>=maxnumber){
                    success = true
                }
                //原来界面没有值，模型数据中有值
                if(gmodel.tiles[index] > 0 && tileVals.indexForKey(key)==nil){
                    insertTile((i,j), value:gmodel.tiles[index], atype:Animation2048Type.Merge)
                }
                //原来界面有值，模型数据中没有值了
                if(gmodel.tiles[index] == 0 && tileVals.indexForKey(key) != nil){
                    tile = tiles[key]!
                    tile.removeFromSuperview()
                    tiles.removeValueForKey(key)
                    tileVals.removeValueForKey(key)
                }
                //原来也有值，现在还有值
                if(gmodel.tiles[index] > 0 && tileVals.indexForKey(key) != nil){
                    tileVal = tileVals[key]!
                    if(tileVal != gmodel.tiles[index]){
                        tile = tiles[key]!
                        tile.removeFromSuperview()
                        tiles.removeValueForKey(key)
                        tileVals.removeValueForKey(key)
                        insertTile((i,j), value:gmodel.tiles[index], atype:Animation2048Type.Merge)
                    }
                }
            }
        }
        if(success){
            var alertView = UIAlertView()
            alertView.title = "恭喜您通关"
            alertView.message = "嘿，真棒，您通关了！"
            alertView.addButtonWithTitle("确定!")
            alertView.show()
            self.resetTapped()
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
        //resetUI()
        initUI()
        genNumber()
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
        //resetUI()
        initUI()
        genNumber()
    }
    func swipeLeft(){
        println("swipeLeft")
        gmodel.reflowLeft()
        gmodel.mergeLeft()
        gmodel.reflowLeft()
        //resetUI()
        initUI()
        genNumber()
    }
    func swipeRight(){
        println("swipeRight")
        gmodel.reflowRight()
        gmodel.mergeRight()
        gmodel.reflowRight()
        //resetUI()
        initUI()
        genNumber()
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
        insertTile((row, col), value:seed, atype:Animation2048Type.New)
    }
    
    func insertTile(pos:(Int, Int), value:Int, atype:Animation2048Type){
        let (row, col) = pos;
        let x = fromX + CGFloat(col) * (width + padding)
        let y = fromY + CGFloat(row) * (width + padding)
        let tile = TileView(pos:CGPointMake(x, y), width:width, value:value)
        self.view.addSubview(tile)
        self.view.bringSubviewToFront(tile)
        var index = NSIndexPath(forRow:row, inSection:col)
        tiles[index]=tile;
        tileVals[index]=value;
        if(atype==Animation2048Type.New){
            tile.layer.setAffineTransform(CGAffineTransformMakeScale(0.1, 0.1))
        }else if(atype==Animation2048Type.Merge){
            tile.layer.setAffineTransform(CGAffineTransformMakeScale(0.8, 0.8))
        }else{
            return
        }
        
        
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
