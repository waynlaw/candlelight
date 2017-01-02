//
//  ConfigureController.swift
//  candlelight
//
//  Created by Lawrence on 2017. 1. 2..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//

import UIKit

class ConfigureController: UIViewController {
    
    static let collectionReuseIdentifier = "collectionCell"
    
    let bottomMenuController: BottomMenuController?
    
    required init?(coder aDecoder: NSCoder) {
        self.bottomMenuController = nil
        
        super.init(coder: aDecoder)
    }
    
    init(bottomMenuController: BottomMenuController) {
        self.bottomMenuController = bottomMenuController
        
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        
        let root = UIView()
        let mainRect = UIScreen.main.bounds
        root.frame = CGRect(x: 0, y: 0, width: mainRect.width, height: mainRect.height)

        bottomMenuController?.setCurrentController(self)
        bottomMenuController?.setupBottomButtons(parent: root)
        
        root.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        
        
        let clianSwitch = UISwitch()
        
        let ddanziSwitch = UISwitch()

        // 여기 할 차례
        clianSwitch.pressesChanged(<#T##presses: Set<UIPress>##Set<UIPress>#>, with: <#T##UIPressesEvent?#>)

        root.addSubview(clianSwitch)
        root.addSubview(ddanziSwitch)
        
        self.view = root
    }
    
}
