import UIKit

class BoardViewController: UIViewController {

    static let collectionReuseIdentifier = "collectionCell"

    let bottomMenuController: BottomMenuController?

    var collectionSource: BoardCollectionViewDelegate?
    var crawler: ListCrawler?

    required init?(coder aDecoder: NSCoder) {
        self.bottomMenuController = nil

        super.init(coder: aDecoder)
    }

    init(crawler: ListCrawler, bottomMenuController: BottomMenuController) {
        self.bottomMenuController = bottomMenuController

        super.init(nibName: nil, bundle: nil)

        self.crawler = crawler
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

        setupCollectionView(parent: root)
        bottomMenuController?.setCurrentController(self)
        bottomMenuController?.setupBottomButtons(parent: root)

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

        let source = BoardCollectionViewDelegate(self)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(SiteCollectionViewCell.self, forCellWithReuseIdentifier: ViewController.collectionReuseIdentifier)
        collectionView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        collectionView.dataSource = source
        collectionView.delegate = source
        source.collectionView = collectionView

        parent.addSubview(collectionView)

        collectionSource = source

        crawler?.getList().onSuccess { result in
                    source.setBoardList(boardItems: result)
                }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

