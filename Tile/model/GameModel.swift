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
    
    init(dimension:Int){
        self.dimension = dimension
        initTiles()
    }
    
    func initTiles(){
        self.tiles = Array<Int>(count:self.dimension * self.dimension, repeatedValue:0)
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
    
    func emptyPositions()->Int[]{
        var emptytiles = Array<Int>()
        for i in 0..(dimension * dimension){
            if(tiles[i] == 0){
                emptytiles += i
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
    
}
