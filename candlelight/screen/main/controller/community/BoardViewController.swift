import UIKit
import GradientLoadingBar

class BoardViewController: UIViewController {

    static let collectionReuseIdentifier = "collectionCell"

    var community: Community = Community.CLIEN
    let bottomMenuController: BottomMenuController?

    var collectionSource: BoardCollectionViewDelegate?
    var refreshControl: UIRefreshControl?
    var crawler: BoardCrawler?
    var boardItems = [BoardItem]()
    var boardPage = 0

    required init?(coder aDecoder: NSCoder) {
        self.bottomMenuController = nil

        super.init(coder: aDecoder)
    }

    init(community: Community, bottomMenuController: BottomMenuController) {
        self.community = community
        self.bottomMenuController = bottomMenuController

        super.init(nibName: nil, bundle: nil)

        self.crawler = boardCrawler(community)
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
        bottomMenuController?.setupBottomButtons(parent: root, type: .home)

        self.view = root
    }

    func setupCollectionView(parent: UIView) {
        let parentFrame = parent.frame
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let frame = CGRect(
            x: parentFrame.origin.x,
            y: parentFrame.origin.y + statusBarHeight,
            width: parentFrame.size.width,
            height: parentFrame.size.height
        )

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.size.width, height: 50)
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1

        let source = BoardCollectionViewDelegate(self, community)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(SiteCollectionViewCell.self, forCellWithReuseIdentifier: CommunityController.collectionReuseIdentifier)
        collectionView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        collectionView.dataSource = source
        collectionView.delegate = source
        collectionView.contentInset = UIEdgeInsetsMake(-statusBarHeight, 0, 0, 0)
        source.collectionView = collectionView

        let refreshControl = UIRefreshControl()
        let textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes:[NSForegroundColorAttributeName: textColor])
        refreshControl.addTarget(self, action:#selector(onRefreshList), for: .valueChanged)
        collectionView.addSubview(refreshControl) // not required when using UITableViewController
        self.refreshControl = refreshControl

        parent.addSubview(collectionView)

        collectionSource = source

        onNeedToMoreList()
    }
    
    func onNeedToMoreList() {
        GradientLoadingBar.sharedInstance().show()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        crawler?.getList(page: boardPage).onSuccess { result in
            if let resultList = result {
                self.updateList(newItems: resultList)
                self.boardPage += 1
                self.collectionSource?.setBoardList(boardItems: self.boardItems)
            }

            GradientLoadingBar.sharedInstance().hide()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    func onRefreshList() {
        self.boardPage = 0
        self.boardItems.removeAll(keepingCapacity: false)
        self.collectionSource?.setBoardList(boardItems: self.boardItems)
        self.refreshControl?.endRefreshing()

        onNeedToMoreList()
    }

    func updateList(newItems:[BoardItem]) {
        var listIdx = 0
        var newIdx = 0
        let newItemsNum = newItems.count
        while (listIdx < self.boardItems.count) {
            if (newIdx >= newItemsNum) {
                break
            }
            if (newItems[newIdx].id == self.boardItems[listIdx].id) {
                self.boardItems[listIdx] = newItems[newIdx]
                newIdx += 1
            } else if (newItems[newIdx].id > self.boardItems[listIdx].id) {
                self.boardItems.insert(newItems[newIdx], at: listIdx)
                newIdx += 1
            }
            listIdx += 1
        }
        for idx in newIdx ..< newItemsNum {
            self.boardItems.append(newItems[idx])
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

