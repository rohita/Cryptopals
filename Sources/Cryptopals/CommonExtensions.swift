import Foundation

extension Int {
    func toChar() -> String {
        return String(format: "%c", self)
    }
}

extension String {
    func `repeat`(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }
}
