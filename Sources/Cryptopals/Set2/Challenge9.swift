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
    func pkcs7(bufferedInput: Data, blockSize: Int) -> Data {
        let inputLength = bufferedInput.count
        
        /*
         If the length of the original data is an integer multiple of the block size B, then an extra block of
         bytes with value B is added. This is necessary so the deciphering algorithm can determine with certainty
         whether the last byte of the last block is a pad byte indicating the number of padding bytes added or
         part of the plaintext message.
         */
        let padLen = inputLength < blockSize ? blockSize - inputLength : blockSize - (inputLength % blockSize)
        
        if (padLen == 0) {
            return bufferedInput
        }
        
        // Pad with same digit as the number of bytes required to pad
        // https://en.wikipedia.org/wiki/Padding_(cryptography)#PKCS#5_and_PKCS#7
        let pad = Data.fill(with: padLen)
        var output = Data(bufferedInput)
        output.append(pad)
        return output
    }
}
