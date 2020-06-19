/**
 Single-byte XOR cipher
 ========================
 The hex encoded string:

     1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736
 
 ... has been XOR'd against a single character. Find the key, decrypt the message.

 You can do this by hand. But don't: write code to do it for you.

 How? Devise some method for "scoring" a piece of English plaintext. Character frequency is a good metric. Evaluate each output and choose the one with the best score.
*/

import Foundation

struct Challenge3 {

    /*
     Given a string that has been 'encrypted' by a single byte XOR cipher,
     attempts to work out which byte was used by brute force testing every
     possible byte and testing the 'englishness' of the result. Returns the
     decrypted string and the byte that decrypted it.
     */
    public func findLikelyPlaintext(_ hexString: String) -> Decrypted {
        let data = Data(fromHexEncodedString: hexString)!
        var outputList = [Decrypted]()
        
        for ascii in 0...255 {
            outputList.append(decrypt(data, using: ascii))
        }
        
        // Pick the one with highest englishness score
        return outputList.max { a, b in a.score < b.score }!
    }
    
    func decrypt(_ data: Data, using ascii: Int) -> Decrypted {
        var tempBuffer = Data()
        for i in 0..<data.count {
            tempBuffer.append(data[i] ^ UInt8(ascii))  // xor each char in buffer with ascii
        }
        let plaintext = tempBuffer.english()
        let score = Englishness.score(input: plaintext)
        
        if (score > 0.7) {
            print(String(format: "%c : %f : %@", ascii, score, plaintext))
        }
        
        return Decrypted(
            key: ascii,
            plaintext: plaintext,
            score: score)
    }
    
    public struct Decrypted {
        var key: Int
        var plaintext: String
        var score: Double
    }
}
