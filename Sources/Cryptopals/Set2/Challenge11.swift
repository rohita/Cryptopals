/*
 An ECB/CBC detection oracle
 ===============================
 
 Now that you have ECB and CBC working:
 
 Write a function to generate a random AES key; that's just 16 random bytes.

 Write a function that encrypts data under an unknown key --- that is, a
 function that generates a random key and encrypts under it.

 The function should look like:

     encryption_oracle(your-input)
     => [MEANINGLESS JIBBER JABBER]
 
 Under the hood, have the function append 5-10 bytes (count chosen randomly)
 before the plaintext and 5-10 bytes after the plaintext.

 Now, have the function choose to encrypt under ECB 1/2 the time, and under
 CBC the other half (just use random IVs each time for CBC). Use rand(2) to
 decide which to use.

 Detect the block cipher mode the function is using each time. You should end
 up with a piece of code that, pointed at a block box that might be encrypting
 ECB or CBC, tells you which one is happening.
 */

import Foundation

class Challenge11 {
    
    // function to generate a random AES key; that's just 16 random bytes.
    func generateRandomKey(length: Int) -> Data {
        var output = Data(capacity: length)
        for _ in 0..<length {
            output.append(UInt8.random(in: 0...255))
        }
        return output
    }
    
    // function append 5-10 bytes (count chosen randomly) before
    // the plaintext and 5-10 bytes after the plaintext.
    func appendRandomBytes(to plainText: Data) -> Data {
        
        // generate random bytes between 5 and 10 length
        let appendBefore = generateRandomKey(length: Int.random(in: 5...10))
        let appendAfter = generateRandomKey(length: Int.random(in: 5...10))
        
        var output = Data(capacity: plainText.count + appendBefore.count + appendAfter.count)
        output.append(appendBefore)
        output.append(plainText)
        output.append(appendAfter)
        
        return output
    }
    
    func randomEncrypt(_ input: Data) -> (mode: String, ciphertext: Data) {
        let plaintext = appendRandomBytes(to: input)
        let key = generateRandomKey(length: 16)
        
        // choose ECB or CBC randomly
        if (Int.random(in: 1...100) > 50) {
            let iv = generateRandomKey(length: 16)
            let encrypted = Challenge10().encryptCBC(bufferedInput: plaintext, keyData: key, iv: iv)
            return ("CBC", encrypted)
        }
        
        return ("ECB", Challenge7().encryptECB(plainData: plaintext, keyData: key)!)
    }
    
    func oracle(ciphertext: Data) -> String {
        return Challenge8().detectECB(bufferedInput: ciphertext, blockSize: 16) ? "ECB" : "CBC"
    }
}
