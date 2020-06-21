/**
 Wrapper for Data
 */

import Foundation

struct Buffer {
    let data : Data
    
    static func from(_ string: String, encoding: Buffer.Encoding) -> Buffer {
        return Buffer(data: Data.from(string, encoding: encoding)!)
    }
    
    func repeatingKeyXOR(with key: String, encoding: Buffer.Encoding) -> Buffer {
        let bufferedKey = Data.from(key, encoding: encoding)!
        let keyLength = bufferedKey.count
        
        var output = Data()
        for i in 0..<data.count {
            output.append(data[i] ^ bufferedKey[i % keyLength])
        }
        return Buffer(data: output)
    }
    
    func toString(encoding: Buffer.Encoding) -> String {
        switch encoding {
        case .base64:
            return data.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        case .hex:
            return data.map { String(format: "%02hhx", $0) }.joined()
        default:
            return String(decoding: data, as: UTF8.self)
        }
    }
    
    
    enum Encoding {
        case hex, utf8, base64
    }
}
