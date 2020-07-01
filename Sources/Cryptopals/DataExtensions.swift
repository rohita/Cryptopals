/**
 Helper extensions to Data class
 */

import Foundation

// Data is a collection on UInt8
extension Data {
    
    enum Encoding {
        /*
         Cleartext is immediately understandable to a human being without additional processing.
         Eg. "Cooking MC's like a pound of bacon". It is close to, but not entirely the same as
         the term "plaintext". Formally, plaintext is information that is fed as an input to a
         coding process, while ciphertext is what comes out of that process. Plaintext might be
         compressed, coded, or otherwise changed before it is converted to ciphertext, so it is
         quite common to find plaintext that is not cleartext. Ref: https://simple.wikipedia.org/wiki/Cleartext
         */
        case cleartext
        case hex
        case base64
    }
    
    static func from(_ string: String, in encoding: Encoding) -> Data? {
        switch encoding {
        case .hex:
            return Data(fromHexEncodedString: string)
        case .cleartext:
            return string.data(using: .utf8)
        case .base64:
            return Data(base64Encoded: string, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        }
    }
    
    private init?(fromHexEncodedString string: String) {

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
    
    func toString(in encoding: Encoding) -> String {
        switch encoding {
        case .base64:
            return self.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        case .hex:
            return map { String(format: "%02hhx", $0) }.joined()
        case .cleartext:
            return String(decoding: self, as: UTF8.self)
        }
    }
    
    func breakIntoBlocks(ofSize blockSize: Int) -> [Data] {
        var blocks = [Data]()
        
        // break input into blockSize blocks
        for startIndex in stride(from: 0, to: self.count, by: blockSize)  {
            var block = Data(count: blockSize)
            let endIndex = startIndex + blockSize > self.count ? self.count : startIndex + blockSize
            let rangeToCopy = startIndex..<endIndex
            
            block.replaceSubrange(0..<(rangeToCopy.count), with: self.subdata(in: rangeToCopy))
            blocks.append(block)
        }
        
        return blocks
    }
    
    static func +(left: Data, right: Data) -> Data {
        var output = Data(left)
        output.append(right)
        return output
    }
        
//        var charArray = [Character]()
//        charArray = map { Character(UnicodeScalar($0)) }
//        return String(charArray)
}

extension Int {
    func toChar() -> String {
        return String(format: "%c", self)
    }
}
