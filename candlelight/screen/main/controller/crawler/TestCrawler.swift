import Foundation
import BrightFutures
import Result

class TestCrawler: ListCrawler {

    func getList() -> Future<[ListItem], NoError> {
        return result()
    }

    func getList(page: Int) -> Future<[ListItem], NoError> {
        return result()
    }

    func result() -> Future<[ListItem], NoError> {
        return Future(value: [
                ListItem(id: 1, title: "TestA", url: "http://test", author: "Unknown", date: "", readCount: 10),
                ListItem(id: 2, title: "TestB", url: "http://test", author: "Unknown", date: "", readCount: 20),
                ListItem(id: 3, title: "TestC", url: "http://test", author: "Unknown", date: "", readCount: 30)
        ])
    }
}
