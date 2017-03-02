import UIKit

class BookmarkViewCell: UICollectionViewCell {

    var textLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let leftMargin = 20.0 as CGFloat
        textLabel = UILabel(frame: CGRect(x: leftMargin, y: 0, width: frame.size.width - leftMargin, height: frame.size.height))
        textLabel.textAlignment = .left
        textLabel.textColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        contentView.addSubview(textLabel)
    }

    func setText(_ text: String) {
        textLabel.text = text
    }
}