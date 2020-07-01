/**
 PKCS#7 padding validation
 ===========================
 
 Write a function that takes a plaintext, determines if it has valid PKCS#7 padding, and strips the padding off.

 The string:

     "ICE ICE BABY\x04\x04\x04\x04"
 
 ... has valid padding, and produces the result "ICE ICE BABY".

 The string:

     "ICE ICE BABY\x05\x05\x05\x05"
 
 ... does not have valid padding, nor does:

     "ICE ICE BABY\x01\x02\x03\x04"
 
 If you are writing in a language with exceptions, like Python or Ruby, make your function throw an exception on bad padding.
 */

import Foundation

class Challenge15 {
    func removePad(bufferedInput: Data, blockSize: Int) throws -> Data {
        for padLen in 1...blockSize {
            let pad = Data.fill(with: padLen, count: padLen)
            if (bufferedInput.suffix(padLen) == pad) {
                return bufferedInput.dropLast(padLen)
            }
        }
        throw CryptopalsError.invalidPKCS7Padding
    }
}
