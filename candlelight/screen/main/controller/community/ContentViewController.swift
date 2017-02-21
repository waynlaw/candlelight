import UIKit

class ContentViewController: UIViewController {

    static let collectionReuseIdentifier = "collectionCell"

    let bottomMenuController: BottomMenuController?

    var crawler: ContentCrawler?
    var contentWebView: UIWebView?

    required init?(coder aDecoder: NSCoder) {
        self.bottomMenuController = nil

        super.init(coder: aDecoder)
    }

    init(_ url: String, bottomMenuController: BottomMenuController) {
        self.bottomMenuController = bottomMenuController
        self.crawler = ClienParkContentCrawler(url)

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
                .onSuccess { result in
                    let url = URL(string: "http://www.clien.net/cs2/bbs/")
                    let html = self.fullHtmlFromBody(result.content)
                    webview.loadHTMLString(html, baseURL: url)
                }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func fullHtmlFromBody(_ body: String) -> String {
        let header = "<html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:fb=\"http://www.facebook.com/2008/fbml\"><head></head><body><font color=\"#BFBFBF\">";
        let footer = "</body></html>";
        return header + body + footer;
    }
}

