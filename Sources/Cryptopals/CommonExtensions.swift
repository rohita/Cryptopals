import Foundation

extension String {
    func `repeat`(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }
    
    func uriEncode() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    static func from(charCode: Int) -> String {
        return String(format: "%c", charCode)
    }
}
