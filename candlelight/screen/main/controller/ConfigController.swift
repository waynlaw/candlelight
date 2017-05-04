//
//  ConfigureController.swift
//  candlelight
//
//  Created by Lawrence on 2017. 1. 2..
//  Copyright © 2017년 Waynlaw. All rights reserved.
//

import UIKit

class ConfigController: UIViewController {
    
    static let collectionReuseIdentifier = "collectionCell"
    
    let pieMenuLocManager: PieMenuLocationManager = PieMenuLocationManager()
    
    let bottomMenuController: BottomMenuController?
    
    var collectionSource: SiteConfigDelegate?
    
    var valueLable: UILabel?
    
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
    }
    
    override func loadView() {
        super.loadView()
        
        let root = UIView()
        let mainRect = UIScreen.main.bounds
        root.frame = CGRect(x: 0, y: 0, width: mainRect.width, height: mainRect.height)
        
        let statusBarView = UIView()
        statusBarView.frame = UIApplication.shared.statusBarFrame
        statusBarView.backgroundColor = UIColor.black
        root.addSubview(statusBarView)
        
        root.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        
        setupCommunityCollectionView(parent: root)
        bottomMenuController?.setupBottomButtons(parent: root, type: .config)
        
        setupPieMenuCollectionView(parent: root)
        
        self.view = root
    }
 
    func setupCommunityCollectionView(parent: UIView) {
        let parentFrame = parent.frame
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        
        let frame = CGRect(
            x: parentFrame.origin.x,
            y: parentFrame.origin.y + statusBarHeight,
            width: parentFrame.size.width,
            height: 50 * 3
        )
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.size.width, height: 50)
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1

        let source = SiteConfigDelegate(self)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(SiteCollectionViewCell.self, forCellWithReuseIdentifier: CommunityController.collectionReuseIdentifier)
        collectionView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        collectionView.dataSource = source
        collectionView.delegate = source
//        collectionView.contentInset = UIEdgeInsetsMake(-statusBarHeight, 0, 0, 0)
        
        parent.addSubview(collectionView)
        
        collectionSource = source
    }
    
    func setupPieMenuCollectionView(parent: UIView) {
        let parentFrame = parent.frame
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        
        let frame = CGRect(
            x: parentFrame.origin.x,
            y: parentFrame.origin.y + statusBarHeight + 50 * 3 + 20,
            width: parentFrame.size.width,
            height: 50
        )
        
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        view.frame = frame
        
        let titelLabel = UILabel(frame: CGRect(x: 10, y: 0, width: frame.size.width, height: frame.size.height))
        titelLabel.textAlignment = .left
        titelLabel.text = "파이메뉴 위치"
        titelLabel.textColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        view.addSubview(titelLabel)
        
        valueLable = UILabel(frame: CGRect(x: -10, y: 0, width: frame.size.width, height: frame.size.height))
        valueLable!.textAlignment = .right
        valueLable!.text = pieMenuLocManager.select() ? "오른쪽" : "왼쪽"
        valueLable!.textColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        view.addSubview(valueLable!)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ConfigController.toggleLocationOfPieMenu))
        
        view.addGestureRecognizer(gesture)
        
        parent.addSubview(view)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func toggleLocationOfPieMenu(sender: UITapGestureRecognizer) {
        pieMenuLocManager.toggle()
        valueLable?.text = pieMenuLocManager.select() ? "오른쪽" : "왼쪽"
    }
}
