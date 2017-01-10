import Foundation
import UIKit

class BottomMenuController: NSObject {
    weak var current: UIViewController? = nil
    var controllers = [BottomMenuType: UIViewController]()

    func setupBottomButtons(parent: UIView) {
        let btnCount = BottomMenuType.all.count
        let buttonHeight = 44.0 as CGFloat

        let parentWidth = Int(parent.frame.width)
        let parentHeight = parent.frame.height
        for menuType in BottomMenuType.all {
            let idx = menuType.rawValue
            let button = UIButton(type: UIButtonType.custom)
            let left = CGFloat(parentWidth * idx / btnCount)
            let right = CGFloat(parentWidth * (idx + 1) / btnCount)
            button.frame = CGRect(x: left, y: parentHeight - buttonHeight, width: right - left, height: buttonHeight)
            button.backgroundColor = UIColor(red: 0.1058, green: 0.1058, blue: 0.1058, alpha: 1.0)
            button.setImage(UIImage(named: buttonImage(menuType)), for: UIControlState.normal)
            button.tag = menuType.rawValue
            button.addTarget(self, action: #selector(BottomMenuController.onClickItem(_:)), for: .touchUpInside)
            parent.addSubview(button)
        }

        let dividerHeight = 1.0 as CGFloat
        let divider = UIView()
        let dividerTop = parentHeight - buttonHeight - dividerHeight
        divider.backgroundColor = UIColor(red: 0.2431, green: 0.2431, blue: 0.2431, alpha: 1.0)
        divider.frame = CGRect(x: parent.frame.origin.x, y: dividerTop, width: parent.frame.width, height: dividerHeight)
        parent.addSubview(divider)
    }

    func buttonImage(_ menuType: BottomMenuType) -> String {
        switch menuType {
        case .board: return "images/btn_1.png"
        case .site: return "images/btn_2.png"
        case .undefined_1: return "images/btn_3.png"
        case .undefined_2: return "images/btn_4.png"
        case .configure: return "images/btn_5.png"
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
        navigationController.setViewControllers([controller], animated: true)
    }
}
