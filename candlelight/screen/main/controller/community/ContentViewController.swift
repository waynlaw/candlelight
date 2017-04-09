import UIKit

class ContentViewController: UIViewController, UIWebViewDelegate {

    static let collectionReuseIdentifier = "collectionCell"

    let bottomMenuController: BottomMenuController?

    var crawler: ContentCrawler?
    var contentWebView: UIWebView?
    var contentsInfo: ListItem?
    var progressView: ProgressView?

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
        let frame = CGRect(x: parentFrame.origin.x, y: parentFrame.origin.y, width: parentFrame.size.width, height: parentFrame.size.height - BottomMenuController.bottomMenuHeight)

        let webView: UIWebView = UIWebView(frame: frame)
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        webView.delegate = self
        parent.addSubview(webView)

        contentWebView = webView

        crawler?.getContent()
            .onSuccess { article in
                webView.loadHTMLString(article.toHtml(), baseURL: nil)
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

