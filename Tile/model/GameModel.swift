//
//  File.swift
//  Tile
//
//  Created by Lamb on 14-6-19.
//  Copyright (c) 2014年 mynah. All rights reserved.
//

import Foundation

class GameModel{
    
    var dimension:Int = 0;
    
    var tiles:Array<Int>!
    
    var mtiles:Array<Int>!
    
    var scoreDelegate:ScoreViewProtocol!
    
    var bestScoreDelegate:ScoreViewProtocol!
    
    var score:Int = 0
    
    var bestScore:Int = 0
    
    init(dimension:Int, scoreDelegate:ScoreViewProtocol, bestScoreDelegate:ScoreViewProtocol){
        self.dimension = dimension
        self.scoreDelegate = scoreDelegate
        self.bestScoreDelegate = bestScoreDelegate
        initTiles()
    }
    
    func initTiles(){
        self.tiles = Array<Int>(count:self.dimension * self.dimension, repeatedValue:0)
        self.mtiles = Array<Int>(count:self.dimension * self.dimension, repeatedValue:0)
    }

    //如果返回false,表示该位置已经有值
    func setPosition(row:Int, col:Int, value:Int) -> Bool{
        assert(row >= 0 && row < dimension)
        assert(col >= 0 && col < dimension)
        //3行4列,即row＝2，col=3 index=2*3+3=11
        //4行4列,即3*4+3=15
        var index = self.dimension * row + col
        var val = tiles[index]
        if(val > 0){
            println("该位置已经有值了")
            return false
        }
        tiles[index] = value
        return true;
    }
    
    func emptyPositions()->[Int]{
        var emptytiles = Array<Int>()
        for i in 0..<(dimension * dimension){
            if(tiles[i] == 0){
                emptytiles.append(tiles[i])
            }
        }
        return emptytiles
    }

    func isFull()->Bool{
        if(emptyPositions().count == 0){
            return true
        }
        return false
    }
    
    func copyToMtiles(){
        for i in 0..<self.dimension * self.dimension{
            mtiles.removeAtIndex(i)
            mtiles.insert(tiles[i], atIndex: i)
        }
    }
    
    func copyFromMtiles(){
        for i in 0..<self.dimension * self.dimension{
            tiles.removeAtIndex(i)
            tiles.insert(mtiles[i], atIndex: i)
        }
    }
    
    func reflowUp(){
        copyToMtiles()
        var index:Int
        for(var i = dimension - 1; i > 0; i--){
            for j in 0..<dimension{
                index = self.dimension * i + j;
                if(mtiles[index - self.dimension]==0&&(mtiles[index]>0)){
                    mtiles[index-self.dimension] = mtiles[index]
                    mtiles[index] = 0
                    var subindex = index
                    while(subindex + self.dimension < mtiles.count){
                        if(mtiles[subindex + self.dimension] > 0){
                            mtiles[subindex] = mtiles[subindex + self.dimension]
                            mtiles[subindex + self.dimension] = 0
                        }
                        subindex += self.dimension
                    }
                }
            }
        }
        copyFromMtiles()
    }
    
    func reflowDown(){
        copyToMtiles()
        var index:Int
        for i in 0..<dimension - 1{
            for j in 0..<dimension{
                index = self.dimension * i + j;
                if(mtiles[index + self.dimension]==0&&(mtiles[index]>0)){
                    mtiles[index+self.dimension] = mtiles[index]
                    mtiles[index] = 0
                    var subindex = index
                    while(subindex - self.dimension >= 0){
                        if(mtiles[subindex - self.dimension] > 0){
                            mtiles[subindex] = mtiles[subindex - self.dimension]
                            mtiles[subindex - self.dimension] = 0
                        }
                        subindex -= self.dimension
                    }
                }
            }
        }
        copyFromMtiles()
    }
    
    func reflowLeft(){
        copyToMtiles()
        var index:Int
        for i in 0..<dimension{
            for(var j = dimension - 1; j > 0; j--){
                index = self.dimension * i + j;
                if(mtiles[index - 1]==0&&(mtiles[index]>0)){
                    mtiles[index - 1] = mtiles[index]
                    mtiles[index] = 0
                    var subindex = index
                    while(subindex + 1 < i*dimension + dimension){
                        if(mtiles[subindex + 1] > 0){
                            mtiles[subindex] = mtiles[subindex + 1]
                            mtiles[subindex + 1] = 0
                        }
                        subindex += 1
                    }
                }
            }
        }
        copyFromMtiles()
    }
    
    func reflowRight(){
        copyToMtiles()
        var index:Int
        for i in 0..<dimension{
            for j in 0..<dimension - 1{
                index = self.dimension * i + j;
                if(mtiles[index + 1]==0&&(mtiles[index]>0)){
                    mtiles[index + 1] = mtiles[index]
                    mtiles[index] = 0
                    var subindex = index
                    while(subindex - 1 > i*dimension - 1){
                        if(mtiles[subindex - 1] > 0){
                            mtiles[subindex] = mtiles[subindex - 1]
                            mtiles[subindex - 1] = 0
                        }
                        subindex -= 1
                    }
                }
            }
        }
        copyFromMtiles()
    }
    
    func mergeUp(){
        copyToMtiles()
        var index:Int
        for(var i = dimension - 1; i > 0; i--){
            for j in 0..<dimension{
                index = self.dimension * i + j;
                if(mtiles[index]>0&&mtiles[index - self.dimension]==mtiles[index]){
                    mtiles[index - self.dimension] = mtiles[index]*2
                    changeScore(mtiles[index]*2)
                    mtiles[index] = 0
                }
            }
        }
        copyFromMtiles()
    }
    
    func mergeDown(){
        copyToMtiles()
        var index:Int
        for i in 0..<dimension - 1{
            for j in 0..<dimension{
                index = self.dimension * i + j;
                if(mtiles[index]>0&&mtiles[index + self.dimension]==mtiles[index]){
                    mtiles[index+self.dimension] = mtiles[index]*2
                    changeScore(mtiles[index]*2)
                    mtiles[index] = 0
                }
            }
        }
        copyFromMtiles()
    }
    
    func mergeLeft(){
        copyToMtiles()
        var index:Int
        for i in 0..<dimension{
            for(var j = dimension - 1; j > 0; j--){
                index = self.dimension * i + j;
                if(mtiles[index]>0&&mtiles[index - 1]==mtiles[index]){
                    mtiles[index - 1] = mtiles[index]*2
                    changeScore(mtiles[index]*2)
                    mtiles[index] = 0
                }
            }
        }
        copyFromMtiles()
    }
    
    func mergeRight(){
        copyToMtiles()
        var index:Int
        for i in 0..<dimension{
            for j in 0..<dimension - 1{
                index = self.dimension * i + j;
                if(mtiles[index]>0&&mtiles[index + 1]==mtiles[index]){
                    mtiles[index + 1] = mtiles[index]*2
                    changeScore(mtiles[index]*2)
                    mtiles[index] = 0
                }
            }
        }
        copyFromMtiles()
    }
    
    func changeScore(s:Int){
        score += s
        if(bestScore < score){
            bestScore = score
        }
        println("\(score)|\(bestScore)");
        scoreDelegate.changeScore(value: score)
        bestScoreDelegate.changeScore(value: bestScore)
    }
    
}