import Foundation
import UIKit

class BottomMenuController: NSObject {
    static let buttonHeight: CGFloat = 30.0 as CGFloat
    static let nameheight: CGFloat = 14.0 as CGFloat
    static let dividerHeight: CGFloat = 1.0 as CGFloat
    static let bottomMenuHeight: CGFloat = buttonHeight + dividerHeight + nameheight

    weak var current: UIViewController? = nil
    var controllers = [BottomMenuType: UIViewController]()

    func setupBottomButtons(parent: UIView) {
        let btnCount = BottomMenuType.all.count


        let parentWidth = Int(parent.frame.width)
        let parentHeight = parent.frame.height
        
        for menuType in BottomMenuType.all {
            let idx = menuType.rawValue
            let button = UIButton(type: UIButtonType.custom)
            let left = CGFloat(parentWidth * idx / btnCount)
            let right = CGFloat(parentWidth * (idx + 1) / btnCount)
            button.frame = CGRect(x: left, y: parentHeight - BottomMenuController.buttonHeight - BottomMenuController.nameheight, width: right - left, height: BottomMenuController.buttonHeight)
            button.backgroundColor = UIColor(red: 0.1058, green: 0.1058, blue: 0.1058, alpha: 1.0)
            button.setImage(UIImage(named: buttonImage(menuType)), for: UIControlState.normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.tag = menuType.rawValue
            button.addTarget(self, action: #selector(BottomMenuController.onClickItem(_:)), for: .touchUpInside)
            
            let label = UILabel()
            label.text = String(describing: menuType).capitalized
            label.frame = CGRect(x: left, y: parentHeight - BottomMenuController.nameheight, width: right - left, height: BottomMenuController.nameheight)
            label.backgroundColor = UIColor(red: 0.1058, green: 0.1058, blue: 0.1058, alpha: 1.0)
            label.textAlignment = NSTextAlignment.center
            label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            label.font = UIFont(name: label.font.fontName, size: 10)
            
            parent.addSubview(button)
            parent.addSubview(label)
        }

        let divider = UIView()
        let dividerTop = parentHeight - BottomMenuController.bottomMenuHeight
        divider.backgroundColor = UIColor(red: 0.2431, green: 0.2431, blue: 0.2431, alpha: 1.0)
        divider.frame = CGRect(x: parent.frame.origin.x, y: dividerTop, width: parent.frame.width, height: BottomMenuController.dividerHeight)
        
        parent.addSubview(divider)
    }

    func buttonImage(_ menuType: BottomMenuType) -> String {
        switch menuType {
            case .home: return "images/btn-home-w.png"
            case .like: return "images/btn-like-w.png"
            case .best: return "images/btn-favorites-w.png"
            case .config: return "images/btn-settings-w.png"
        }
    }

    func setController(type: BottomMenuType, controller: UIViewController) {
        controllers[type] = controller
    }

    func setCurrentController(_ currentController: UIViewController) {
        self.current = currentController
    }

    func onClickItem(_ sender: UIButton) {
        guard let type = BottomMenuType(rawValue: sender.tag),
              let controller = controllers[type],
              let navigationController = current?.navigationController else {
            return
        }
        self.current = controller
        navigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        navigationController.setViewControllers([controller], animated: false)
    }
}
