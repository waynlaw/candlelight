import Foundation

enum BottomMenuType: Int {
    case site = 0
    case board
    case undefined_1
    case undefined_2
    case configure

    static let all = [site, board, undefined_1, undefined_2, configure]
}
