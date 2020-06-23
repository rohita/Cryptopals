/**
 Implement PKCS#7 padding
 ===========================
 
 A block cipher transforms a fixed-sized block (usually 8 or 16 bytes) of plaintext into ciphertext. But we almost never want to transform a single block; we encrypt irregularly-sized messages.

 One way we account for irregularly-sized messages is by padding, creating a plaintext that is an even multiple of the blocksize. The most popular padding scheme is called PKCS#7.

 So: pad any block to a specific block length, by appending the number of bytes of padding to the end of the block. For instance,

     "YELLOW SUBMARINE"
 
 ... padded to 20 bytes would be:

     "YELLOW SUBMARINE\x04\x04\x04\x04"
 */

import Foundation

class Challenge9 {
    func pkcs7(plainText: String, blockSize: Int) -> String {
        let bufferedInput = Data.from(plainText, in: .cleartext)!
        let inputLength = bufferedInput.count
        let padLen = inputLength <= blockSize ? blockSize - inputLength : inputLength % blockSize
        
        if (padLen == 0) {
            return bufferedInput.toString(in: .cleartext)
        }
        
        // Pad with same digit as the number of bytes required to pad
        // https://en.wikipedia.org/wiki/Padding_(cryptography)#PKCS#5_and_PKCS#7
        let pad = [UInt8](repeating: UInt8(padLen), count: padLen)
        var output = Data(bufferedInput)
        output.append(contentsOf: pad)
        return output.toString(in: .cleartext)
    }
}
