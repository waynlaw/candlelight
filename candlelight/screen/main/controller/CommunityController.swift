import UIKit

class CommunityController: UIViewController {

    static let collectionReuseIdentifier = "collectionCell"

    let bottomMenuController: BottomMenuController = BottomMenuController()

    var collectionSource: SiteCollectionViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "함께 보기"
    }

    override func loadView() {
        super.loadView()

        let root = UIView()
        let mainRect = UIScreen.main.bounds
        root.frame = CGRect(x: 0, y: 0, width: mainRect.width, height: mainRect.height)

        setupCollectionView(parent: root)
        bottomMenuController.setCurrentController(self)
        bottomMenuController.setController(type: .site, controller: self)
        bottomMenuController.setupBottomButtons(parent: root)
        
        let configureController = ConfigController(bottomMenuController: bottomMenuController)

        bottomMenuController.setController(type: .configure, controller: configureController)
        
        self.view = root
    }

    func setupCollectionView(parent: UIView) {
        let parentFrame = parent.frame
        let frame = CGRect(x: parentFrame.origin.x, y: parentFrame.origin.y, width: parentFrame.size.width, height: parentFrame.size.height)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.size.width, height: 50)
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1

        let source = SiteCollectionViewDelegate(self)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(SiteCollectionViewCell.self, forCellWithReuseIdentifier: CommunityController.collectionReuseIdentifier)
        collectionView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        collectionView.dataSource = source
        collectionView.delegate = source
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

