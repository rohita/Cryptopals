import Foundation

extension String {
    func `repeat`(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }
    
    static func from(charCode: Int) -> String {
        return String(format: "%c", charCode)
    }
}
