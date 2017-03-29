import UIKit

class ContentViewController: UIViewController {

    static let collectionReuseIdentifier = "collectionCell"

    let bottomMenuController: BottomMenuController?

    var crawler: ContentCrawler?
    var contentWebView: UIWebView?
    var contentsInfo: ListItem?

    required init?(coder aDecoder: NSCoder) {
        self.bottomMenuController = nil

        super.init(coder: aDecoder)
    }

    init(_ contentsInfo: ListItem, bottomMenuController: BottomMenuController) {
        self.bottomMenuController = bottomMenuController
        self.crawler = ClienParkArticleCrawler(contentsInfo.url)
        self.contentsInfo = contentsInfo

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

        setupContentsView(parent: root)
        bottomMenuController?.setupBottomButtons(parent: root)

        self.view = root
    }

    func setupContentsView(parent: UIView) {
        let parentFrame = parent.frame
        let frame = CGRect(x: parentFrame.origin.x, y: parentFrame.origin.y, width: parentFrame.size.width, height: parentFrame.size.height)

        let webview: UIWebView = UIWebView(frame: frame)
        webview.isOpaque = false
        webview.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        parent.addSubview(webview)

        contentWebView = webview

        crawler?.getContent()
            .onSuccess { article in
                webview.loadHTMLString(article.toHtml(), baseURL: nil)
        }
        setupBookmarkButton(parent, parentFrame)
    }

    func setupBookmarkButton(_ parent: UIView, _ parentFrame:CGRect) {
        let bookmarkButtonWidth = 100.0 as CGFloat
        let bookmarkButtonHeight = 100.0 as CGFloat
        let xPos = parentFrame.origin.x + parentFrame.size.width - bookmarkButtonWidth
        let yPos = parentFrame.origin.y
        let uiButton = UIButton(type: .system)
        uiButton.setTitle("Bookmark", for: .normal)
        uiButton.frame = CGRect(x: xPos, y: yPos, width: bookmarkButtonWidth, height: bookmarkButtonHeight)
        uiButton.addTarget(self, action: #selector(bookMarkClicked), for: UIControlEvents.touchUpInside)
        parent.addSubview(uiButton)
    }

    func bookMarkClicked() {
        guard let contentsInfo = self.contentsInfo else {
            return
        }
        let bookmarkManager = BookmarkManager()
        let bookmark = BookmarkData()
        bookmark.title = contentsInfo.title
        bookmark.url = contentsInfo.url
        bookmarkManager.upsert(bookmark)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // for test
    func fullHtmlFromBody(_ body: String) -> String {
        let header = "<html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:fb=\"http://www.facebook.com/2008/fbml\"><head></head><body><font color=\"#BFBFBF\">"
        let footer = "</body></html>"
        
        let test = "<h2 style='font-color:yellow'>블라블라블라</h2>"
        return header + test + footer;
    }
}

