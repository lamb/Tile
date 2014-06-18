//
//  ViewController.swift
//  Tile
//
//  Created by Lamb on 14-6-17.
//  Copyright (c) 2014年 mynah. All rights reserved.
//

import UIKit;

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startGame(sender : UIButton) {
        var alertView = UIAlertView()
        alertView.title = "开始"
        alertView.message = "游戏就要开始了，准备好了吗？"
        alertView.addButtonWithTitle("Ready GO!")
        alertView.show()
        alertView.delegate = self
    }

    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        self.presentViewController(TabViewController(), animated:true, completion:nil);
    }
    
}

