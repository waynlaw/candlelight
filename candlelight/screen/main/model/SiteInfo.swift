import Foundation

class SiteInfo {
    let community: Community
    let title: String
    let isOn: Bool

    init(community: Community, title: String, isOn: Bool = false) {
        self.community = community
        self.title = title
        self.isOn = isOn
    }
}
