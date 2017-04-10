import UIKit

class ProgressView: UIView {

    static let lineWidth: CGFloat = 2

    var isFinished: Bool = false
    var myTimer: Timer = Timer()
    var didFinishTimer: Timer = Timer()

    var webViewLoadsCount = 0

    var progress: Float = 0.0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        inits()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        inits()
    }

    func inits() {
        startAnimatingProgressBar()
    }

    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        aPath.lineWidth = ProgressView.lineWidth * 2.0
        aPath.move(to: CGPoint(x: 0, y: 0))
        aPath.addLine(to: CGPoint(x: frame.width * CGFloat(progress * 0.9 + 0.1), y: 0))
        aPath.close()

        UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 1.0, alpha: 1.0).set()
        aPath.stroke()
        aPath.fill()
    }


    func setProgress(progress: Float) {
        self.progress = progress

        setNeedsDisplay()
    }

    func startAnimatingProgressBar() {
        self.isFinished = false
        self.isHidden = false
        self.alpha = 0
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.alpha = 0.6
        })
        self.progress = 0.0

        // Tweek this number to alter the main speed of the progress bar
        let number = drand48() / 80;
        self.myTimer = Timer.scheduledTimer(timeInterval: number, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }

    func finishAnimatingProgressBar() {
        self.isFinished = true
    }

    func timerCallback() {
        // refer: http://stackoverflow.com/questions/28147096/progressbar-webview-in-swift
        if self.isFinished {
            if self.progress >= 1 {
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.alpha = 0
                })
                self.myTimer.invalidate()
            } else {
                //Loaded and zoom to finish
                let number = drand48() / 40

                setProgress(progress: self.progress + Float(number))
            }

        } else {
            //Start slow
            if self.progress >= 0.00 && self.progress <= 0.10 {
                let number = drand48() / 2000;

                setProgress(progress: self.progress + Float(number))
                //Middle speed up a bit
            } else if self.progress >= 0.10 && self.progress <= 0.42 {
                let smallerNumber = drand48() / 1000;
                setProgress(progress: self.progress + Float(smallerNumber))

                //slow it down again
            } else if progress >= 0.42 && self.progress <= 0.90 {
                let superSmallNumber = drand48() / 8000;
                setProgress(progress: self.progress + Float(superSmallNumber))

                //Stop it
            } else if self.progress == 0.90 {
                print("Stop:\(self.progress)")
                setProgress(progress: 0.90)
            }
        }
    }

    func webViewDidStartLoad(webView: UIWebView) {
        webViewLoadsCount += 1

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        webViewLoadsCount -= 1

        if webViewLoadsCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            finishAnimatingProgressBar()
            return
        }
    }

    func webView(webView: UIWebView, didFailLoadWithError error: Error) {
        isFinished = true
        webViewLoadsCount = 0
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
