
import UIKit
import Foundation

protocol TouchPieMenuListener {
    func onBookmark()
    func onShare()
}


class TouchPieMenu : UIView {

    static let size: CGFloat = 120.0

    var centerBtn: UIImageView? = nil
    var fullMenuBtn: UIImageView? = nil
    var listener: TouchPieMenuListener? = nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        inits()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        inits()
    }

    func inits() {
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)

        if let centerImage = UIImage(named: "images/btn-menu.png") {
            let frame = CGRect(x: 0, y: 0, width: centerImage.size.width, height: centerImage.size.height)
            let centerBtn = UIImageView(image: centerImage)
            centerBtn.frame = frame
            centerBtn.center = center
            addSubview(centerBtn)

            self.centerBtn = centerBtn
        }

        if let fullImage = UIImage(named: "images/btn-menu-full.png") {
            let frame = CGRect(x: 0, y: 0, width: fullImage.size.width, height: fullImage.size.height)
            let fullMenuBtn = UIImageView(image: fullImage)
            fullMenuBtn.frame = frame
            fullMenuBtn.center = center
            fullMenuBtn.isHidden = true
            addSubview(fullMenuBtn)

            self.fullMenuBtn = fullMenuBtn
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first,
            let centerBtn = self.centerBtn {
            let location = touch.location(in: self)
            if centerBtn.frame.contains(location) {
                showPieMenu()
            }
        }

        super.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hidePieMenu()

        if let touch = touches.first {
            let pt = touch.location(in: self)
            let halfSize = TouchPieMenu.size / 2
            let dx = pt.x - halfSize
            let dy = pt.y - halfSize
            if 0 > dx && abs(dx) > abs(dy) {
                listener?.onBookmark()
            } else if 0 < dx && abs(dx) > abs(dy) {
                listener?.onShare()
            }
        }

        super.touchesEnded(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        hidePieMenu()

        super.touchesCancelled(touches, with: event)
    }

    private func showPieMenu() {
        fullMenuBtn?.isHidden = false
    }

    private func hidePieMenu() {
        fullMenuBtn?.isHidden = true
    }

    func setListener(_ listener: TouchPieMenuListener) {
        self.listener = listener
    }
}
