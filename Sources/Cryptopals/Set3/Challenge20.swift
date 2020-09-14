/*
 Break fixed-nonce CTR statistically
 ====================================
 
 In this file (20.txt) find a similar set of Base64'd plaintext. Do with them exactly
 what you did with the first, but solve the problem differently. Instead of making spot
 guesses at to known plaintext, treat the collection of ciphertexts the same way you
 would repeating-key XOR.

 Obviously, CTR encryption appears different from repeated-key XOR, but with a fixed
 nonce they are effectively the same thing. To exploit this: take your collection of
 ciphertexts and truncate them to a common length (the length of the smallest ciphertext
 will work).

 Solve the resulting concatenation of ciphertexts as if for repeating- key XOR, with a
 key size of the length of the ciphertext you XOR'd.
 */

import Foundation

class Challenge20 {
    
    func crackFixedNonceCTR(ciphertexts : [Data]) -> [String] {
        // Transpose ciphers blocks
        let transposedInputArr = Challenge6().transposeBlocks(ciphertexts)
        
        // Solve each transposed block as if it was single-character XOR using Challenge3.
        var keyArr = [UInt8]()
        for transposeBlock in transposedInputArr {
            let likelyPlaintext = Challenge3().findLikelyPlaintext(transposeBlock)
            keyArr.append(contentsOf: likelyPlaintext.decryptKey)
        }
        
        // put all the keys together to have the finished key
        let potentialKey = Data(keyArr)
        
        var output = [String]()
        for cipher in ciphertexts {
            let recovered = xor(cipher, potentialKey)
            output.append(recovered)
        }
        
        return output
    }
    
    private func xor(_ ciphertext: Data, _ testKey: Data) -> String {
        return Challenge2().fixedXor(testKey, ciphertext).toString(in: .cleartext)
    }
}
