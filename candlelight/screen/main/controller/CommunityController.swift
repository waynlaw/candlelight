
import UIKit

class CommunityController: UIViewController {

    static let collectionReuseIdentifier = "collectionCell"

    let bottomMenuController: BottomMenuController = BottomMenuController()

    var collectionSource: CommunityViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

//        self.navigationItem.title = "함께 보기"
    }

    override func loadView() {
        super.loadView()

        let root = UIView()
        let mainRect = UIScreen.main.bounds
        root.frame = CGRect(x: 0, y: 0, width: mainRect.width, height: mainRect.height)

        setupCollectionView(parent: root)
        setupBottomMenu(parent: root)
        
        self.view = root
    }
    
    func setupBottomMenu(parent: UIView) {
        bottomMenuController.setCurrentController(self)
        bottomMenuController.setController(type: .home, controller: self)
        bottomMenuController.setupBottomButtons(parent: parent,type: .home)
        
        let configureController = ConfigController(bottomMenuController: bottomMenuController)
        let bookmarkController = BookmarkController(bottomMenuController: bottomMenuController)
        
        bottomMenuController.setController(type: .like, controller: bookmarkController)
        bottomMenuController.setController(type: .config, controller: configureController)
    }

    func setupCollectionView(parent: UIView) {
        let parentFrame = parent.frame
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        
        let frame = CGRect(
            x: parentFrame.origin.x,
            y: parentFrame.origin.y + statusBarHeight,
            width: parentFrame.size.width,
            height: parentFrame.size.height - BottomMenuController.bottomMenuHeight - statusBarHeight
        )

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.size.width, height: 50)
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1

        let source = CommunityViewDelegate(self)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(SiteCollectionViewCell.self, forCellWithReuseIdentifier: CommunityController.collectionReuseIdentifier)
        collectionView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        collectionView.dataSource = source
        collectionView.delegate = source
        collectionView.contentInset = UIEdgeInsetsMake(-statusBarHeight, 0, 0, 0)
        source.collectionView = collectionView

        parent.addSubview(collectionView)

        collectionSource = source
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionSource?.reloadCollectionView()
    }
}

