import UIKit

class ViewController: UIViewController {

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

        setupBottomButtons(parent: root)

        self.view = root
    }

    func setupBottomButtons(parent: UIView) {
        let parentWidth = Int(parent.frame.width)
        let parentHeight = parent.frame.height
        let buttonHeight = 44.0 as CGFloat
        let buttonNum = 5
        for idx in 0 ..< buttonNum {
            let button = UIButton(type: UIButtonType.custom)
            let left = CGFloat(parentWidth * idx / buttonNum)
            let right = CGFloat(parentWidth * (idx + 1) / buttonNum)
            button.frame = CGRect(x: left, y: parentHeight - buttonHeight, width: right - left, height: buttonHeight)
            button.backgroundColor = UIColor(red: 0.1058, green: 0.1058, blue: 0.1058, alpha: 1.0)
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

