//
//  Created by Rohit Agarwal on 6/17/20.
//

import Foundation

// Data is a collection on UInt8
extension Data {
    
    static func from(_ string: String, encoding: Buffer.Encoding) -> Data? {
        switch encoding {
        case .hex:
            return Data(fromHexEncodedString: string)
        case .utf8:
            return string.data(using: .utf8)
        case .base64:
            return Data(base64Encoded: string)
        }
    }
    
    init?(fromHexEncodedString string: String) {

        // Convert 0 ... 9, a ... f, A ...F to their decimal value,
        // return nil for all other input characters
        func decodeNibble(u: UInt16) -> UInt8? {
            switch(u) {
            case 0x30 ... 0x39:
                return UInt8(u - 0x30)
            case 0x41 ... 0x46:
                return UInt8(u - 0x41 + 10)
            case 0x61 ... 0x66:
                return UInt8(u - 0x61 + 10)
            default:
                return nil
            }
        }

        self.init(capacity: string.utf16.count/2)
        var even = true
        var byte: UInt8 = 0
        for c in string.utf16 {
            guard let val = decodeNibble(u: c) else { return nil }
            if even {
                byte = val << 4
            } else {
                byte += val
                self.append(byte)
            }
            even = !even
        }
        guard even else { return nil }
    }
    
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    func english() -> String {
        return String(decoding: self, as: UTF8.self)
        
//        var charArray = [Character]()
//        charArray = map { Character(UnicodeScalar($0)) }
//        return String(charArray)
    }
}
