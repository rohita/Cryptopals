/*
 Single-byte XOR cipher
 ========================
 The hex encoded string:

     1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736
 
 ... has been XOR'd against a single character. Find the key, decrypt the message.

 You can do this by hand. But don't: write code to do it for you.
 How? Devise some method for "scoring" a piece of English plaintext. Character
 frequency is a good metric. Evaluate each output and choose the one with the best score.
*/

import Foundation

class Challenge3 {
    
    public func findLikelyPlaintext(_ hexString: String) -> Decrypted {
        let data = Data.from(hexString, in: .hex)
        return findLikelyPlaintext(data)
    }

    /*
     Given a string that has been 'encrypted' by a single byte XOR cipher,
     attempts to work out which byte was used by brute force testing every
     possible byte and testing the 'englishness' of the result. Returns the
     decrypted string and the byte that decrypted it.
     */
    public func findLikelyPlaintext(_ data: Data) -> Decrypted {
        var outputList = [Decrypted]()
        
        for key in 0...255 {
            outputList.append(decrypt(data, using: key))
        }
        
        // Pick the one with highest englishness score
        return outputList.max { a, b in a.englishnessScore < b.englishnessScore }!
    }
    
    private func decrypt(_ data: Data, using key: Int) -> Decrypted {
        var tempBuffer = Data()
        data.forEach { byte in tempBuffer.append(byte ^ UInt8(key))}  // xor each char in buffer with ascii

        let plaintext = tempBuffer.toString(in: .cleartext)
        let score = Englishness.score(input: plaintext)
        
        return Decrypted(
            ciphertext: data.toString(in: .hex),
            decryptKey: Data([UInt8(key)]),
            cleartext: plaintext,
            englishnessScore: score)
    }
    
    public struct Decrypted : Equatable {
        var ciphertext: String
        var decryptKey: Data
        var cleartext: String
        var englishnessScore: Double
    }
}
