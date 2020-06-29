/**
 Byte-at-a-time ECB decryption (Simple)
 =======================================
 
 Copy your oracle function to a new function that encrypts buffers under ECB mode using a consistent but unknown key (for instance, assign a single random key, once, to a global variable).

 Now take that same function and have it append to the plaintext, BEFORE ENCRYPTING, the following string:

     Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkg
     aGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBq
     dXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUg
     YnkK
 
 Base64 decode the string before appending it. *Do not base64 decode the string by hand; make your code do it.* The point is that you don't know its contents.

 What you have now is a function that produces:

     AES-128-ECB(your-string || unknown-string, random-key)
 
 It turns out: you can decrypt "unknown-string" with repeated calls to the oracle function!

 Here's roughly how:

 1. Feed identical bytes of your-string to the function 1 at a time --- start with 1 byte ("A"), then "AA", then "AAA" and so on. Discover the block size of the cipher. You know it, but do this step anyway.
 2. Detect that the function is using ECB. You already know, but do this step anyways.
 3. Knowing the block size, craft an input block that is exactly 1 byte short (for instance, if the block size is 8 bytes, make "AAAAAAA"). Think about what the oracle function is going to put in that last byte position.
 4. Make a dictionary of every possible last byte by feeding different strings to the oracle; for instance, "AAAAAAAA", "AAAAAAAB", "AAAAAAAC", remembering the first block of each invocation.
 5. Match the output of the one-byte-short input to one of the entries in your dictionary. You've now discovered the first byte of unknown-string.
 6. Repeat for the next byte.
 */

import Foundation

class Challenge12 {
    let secretSauce : Data
    let key : Data = Challenge11().generateRandomKey(length: 16) // static key for testing
    
    init(secretSauce : Data) {
        self.secretSauce = secretSauce
    }
    
    func encryptWithSecretSauce(bufferedInput: Data) -> Data {
        let fullInput = bufferedInput + secretSauce
        return Challenge7().encryptECB(plainData: fullInput, keyData: key)!
    }
    
    func findBlockSize() -> Int {
        // Feed identical bytes of a string to the encrypt function 1 at a time ---
        // start with 1 byte ("A"), then "AA", then "AAA" and so on. Discover the block size of the cipher.
        var i = 1
        var blockGuess = 0
        var currentSize = 0
        
        while (blockGuess < 1 && i <= 256) {
            let currentCT = encryptWithSecretSauce(bufferedInput: Data.from(String(repeating: "A", count: i), in: .cleartext)!)
            if (currentCT.count > currentSize && currentSize > 0) {
                blockGuess = currentCT.count - currentSize   // this will reach only when a new block is added, which will be blocksize boundary
            }
            currentSize = currentCT.count
            i += 1
        }
        return blockGuess
    }
    
    // Detect that the function is using ECB
    func detectECB() -> Bool {
        let blockSize = findBlockSize()
        let payload = String(repeating: "A", count: blockSize*5) // should definitely get a dupe here
        let ciphertext = encryptWithSecretSauce(bufferedInput: Data.from(payload, in: .cleartext)!)
        return Challenge8().detectECB(bufferedInput: ciphertext, blockSize: blockSize)
    }
    
    func crackECB() -> String {
        let blockSize = findBlockSize()
        let ciphertext = encryptWithSecretSauce(bufferedInput: Data.from(String(repeating: "A", count: blockSize), in: .cleartext)!)
        let secretSauceLength = ciphertext.count - blockSize
        var recoveredPlaintext : String = ""
        
        for k in stride(from: 0, to: secretSauceLength, by: blockSize) {
            for j in 1...blockSize {
                var dictionary : [String : Int] = [:]
                let aaaaaaa = Data.from(String(repeating: "A", count: blockSize-j), in: .cleartext)!  // "AAAAAAA..." 15 A's
                let aaaaaaaPlusUnknown = encryptWithSecretSauce(bufferedInput: aaaaaaa).subdata(in: k..<(k+blockSize))  // we know 15 bytes are A's and 16th will be the first from the secret sauce
                
                for i in 0...255 {
                    var currentPayload = Data()
                    currentPayload.append(aaaaaaa)  // 15 A's
                    currentPayload.append(Data.from(recoveredPlaintext, in: .cleartext)!)  // What ever we have discovered so far
                    currentPayload.append(UInt8(i))  // brute force each character for the 16th byte
                    let aaaaaaaPlusKnown = encryptWithSecretSauce(bufferedInput: currentPayload).subdata(in: k..<(k+blockSize)) // we know all 16 bytes
                    dictionary[aaaaaaaPlusKnown.toString(in: .hex)] = i
                }
                
                if let val = dictionary[aaaaaaaPlusUnknown.toString(in: .hex)] {
                    recoveredPlaintext += String(format: "%c", val)  // whichever char matches should be the one
                }
            }
        }
        return recoveredPlaintext
    }
    
}
