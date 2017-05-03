import UIKit
import GradientLoadingBar
import MBProgressHUD
import SVWebViewController

class ContentViewController: UIViewController, UIWebViewDelegate, TouchPieMenuListener {

    static let collectionReuseIdentifier = "collectionCell"

    let bottomMenuController: BottomMenuController?
    let bottomMenuType: BottomMenuType?

    var community: Community = Community.CLIEN
    var crawler: ArticleCrawler?
    var contentWebView: UIWebView?
    var contentsInfo: ListItem?
    var progressView: ProgressView?

    required init?(coder aDecoder: NSCoder) {
        self.bottomMenuController = nil
        self.bottomMenuType = nil

        super.init(coder: aDecoder)
    }

    init(_ contentsInfo: ListItem, _ community: Community, bottomMenuController: BottomMenuController, bottomMenuType: BottomMenuType) {
        self.bottomMenuController = bottomMenuController
        self.community = community
        self.crawler = articleCrawler(community, contentsInfo.url)
        self.contentsInfo = contentsInfo
        self.bottomMenuType = bottomMenuType

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
        setupPieMenuView(parent:root)
        bottomMenuController?.setupBottomButtons(parent: root, type: bottomMenuType!)
        setupProgressView(parent: root)

        self.view = root
    }

    func setupProgressView(parent: UIView) {
        let progressFrame = CGRect(x: 0, y: 0, width: parent.frame.width, height: ProgressView.lineWidth)
        let progressView = ProgressView(frame: progressFrame)
        parent.addSubview(progressView)
        self.progressView = progressView
    }

    private func setupPieMenuView(parent: UIView) {
        let width = TouchPieMenu.size
        let height = TouchPieMenu.size
        let menuFrame = CGRect(x: parent.frame.width - width, y: parent.frame.height - 50 - height, width: width, height: height)
        let pieMenu = TouchPieMenu(frame: menuFrame)
        pieMenu.setListener(self)
        parent.addSubview(pieMenu)
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

        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.customView
        loadingNotification.label.text = "Bookmark Registered."
        loadingNotification.customView =  UIImageView(image: UIImage(named: "images/checkmark.png"))
        loadingNotification.hide(animated:true, afterDelay: 2)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func onBookmark() {
        bookMarkClicked()
    }

    func onShare() {
        guard let contentsInfo = self.contentsInfo else {
            return
        }
        let textToShare = contentsInfo.url
        let urlToShare = URL(string:contentsInfo.url)
        let activities = [SVWebViewControllerActivitySafari(), SVWebViewControllerActivityChrome()];
        let activityViewController = UIActivityViewController(activityItems: [textToShare, urlToShare!], applicationActivities: activities)
        present(activityViewController, animated: true, completion: nil)
    }
}

