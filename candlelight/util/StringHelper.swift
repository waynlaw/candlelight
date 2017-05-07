
import Foundation

extension String {
    func digitsOnly() -> String {
        let stringArray = self.components(separatedBy: CharacterSet.decimalDigits.inverted)
        return stringArray.joined(separator: "")
    }

    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}