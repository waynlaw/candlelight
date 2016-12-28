import UIKit

class BoardViewController: UIViewController {

    static let collectionReuseIdentifier = "collectionCell"
    var collectionSource: BoardCollectionViewDelegate?
    var crawler: ListCrawler?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(crawler: ListCrawler) {
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
        setupBottomButtons(parent: root)

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

    func setupBottomButtons(parent: UIView) {
        let buttonImages = ["images/btn_1.png", "images/btn_2.png", "images/btn_3.png", "images/btn_4.png", "images/btn_5.png"]
        let buttonNum = 5
        let buttonHeight = 44.0 as CGFloat

        let parentWidth = Int(parent.frame.width)
        let parentHeight = parent.frame.height
        for idx in 0 ..< buttonNum {
            let button = UIButton(type: UIButtonType.custom)
            let left = CGFloat(parentWidth * idx / buttonNum)
            let right = CGFloat(parentWidth * (idx + 1) / buttonNum)
            button.frame = CGRect(x: left, y: parentHeight - buttonHeight, width: right - left, height: buttonHeight)
            button.backgroundColor = UIColor(red: 0.1058, green: 0.1058, blue: 0.1058, alpha: 1.0)
            button.setImage(UIImage(named: buttonImages[idx]), for: UIControlState.normal)
            parent.addSubview(button)
        }

        let dividerHeight = 1.0 as CGFloat
        let divider = UIView()
        let dividerTop = parentHeight - buttonHeight - dividerHeight
        divider.backgroundColor = UIColor(red: 0.2431, green: 0.2431, blue: 0.2431, alpha: 1.0)
        divider.frame = CGRect(x: parent.frame.origin.x, y: dividerTop, width: parent.frame.width, height: dividerHeight)
        parent.addSubview(divider)
    }
}

