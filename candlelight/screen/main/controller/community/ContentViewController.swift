import UIKit
import GradientLoadingBar

class ContentViewController: UIViewController, UIWebViewDelegate {

    static let collectionReuseIdentifier = "collectionCell"

    let bottomMenuController: BottomMenuController?

    var community: Community = Community.CLIEN
    var crawler: ArticleCrawler?
    var contentWebView: UIWebView?
    var contentsInfo: ListItem?
    var progressView: ProgressView?

    required init?(coder aDecoder: NSCoder) {
        self.bottomMenuController = nil

        super.init(coder: aDecoder)
    }

    init(_ contentsInfo: ListItem, _ community: Community, bottomMenuController: BottomMenuController) {
        self.bottomMenuController = bottomMenuController
        self.community = community
        self.crawler = articleCrawler(community, contentsInfo.url)
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
        setupProgressView(parent: root)

        self.view = root
    }

    func setupProgressView(parent: UIView) {
        let progressFrame = CGRect(x: 0, y: 0, width: parent.frame.width, height: ProgressView.lineWidth)
        let progressView = ProgressView(frame: progressFrame)
        parent.addSubview(progressView)
        self.progressView = progressView
    }

    func setupContentsView(parent: UIView) {
        let parentFrame = parent.frame
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let frame = CGRect(
            x: parentFrame.origin.x,
            y: parentFrame.origin.y + statusBarHeight,
            width: parentFrame.size.width,
            height: parentFrame.size.height - BottomMenuController.bottomMenuHeight - statusBarHeight
        )

        let webView: UIWebView = UIWebView(frame: frame)
        webView.isOpaque = false
        
        webView.backgroundColor = UIColor(red: 0.58, green: 0.60, blue: 0.65, alpha: 1.0)
        webView.delegate = self
        webView.scrollView.contentInset = UIEdgeInsetsMake(-statusBarHeight, 0, 0, 0)
        parent.addSubview(webView)

        contentWebView = webView

        GradientLoadingBar.sharedInstance().show()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        crawler?.getContent()
            .onSuccess { article in
                webView.loadHTMLString(article.toHtml(), baseURL: nil)
                
                GradientLoadingBar.sharedInstance().hide()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        setupBookmarkButton(parent, parentFrame)
    }

    public func webViewDidStartLoad(_ webView: UIWebView) {
        self.progressView?.webViewDidStartLoad(webView: webView)

    }

    public func webViewDidFinishLoad(_ webView: UIWebView) {
        self.progressView?.webViewDidFinishLoad(webView: webView)
    }

    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.progressView?.webView(webView: webView, didFailLoadWithError: error)
        print(error.localizedDescription)
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
        bookmark.community = community.rawValue
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
}

