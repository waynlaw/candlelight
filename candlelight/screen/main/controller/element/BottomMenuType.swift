import Foundation

enum BottomMenuType: Int {
    case site = 0
    case bookmark
    case undefined_1
    case undefined_2
    case configure

    static let all = [site, bookmark, undefined_1, undefined_2, configure]
}
