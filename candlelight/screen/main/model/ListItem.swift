import Foundation

class ListItem {
    let id: Int
    let title: String
    let url: String
    let author: String
    let date: String
    let readCount: Int

    public init(id: Int, title: String, url: String, author: String, date: String, readCount: Int) {
        self.id = id
        self.title = title
        self.url = url
        self.author = author
        self.date = date
        self.readCount = readCount
    }
}
