/*
 The CBC padding oracle
 ==========================
 This is the best-known attack on modern block-cipher cryptography.
 
 Combine your padding code and your CBC code to write two functions.
 The first function should select at random one of the given 10 strings,
 generate a random AES key (which it should save for all future encryptions),
 pad the string out to the 16-byte AES block size and CBC-encrypt it under
 that key, providing the caller the ciphertext and IV.
 
 The second function should consume the ciphertext produced by the first
 function, decrypt it, check its padding, and return true or false depending
 on whether the padding is valid.
 
 This pair of functions approximates AES-CBC encryption as its deployed
 serverside in web applications; the second function models the server's
 consumption of an encrypted session token, as if it was a cookie.
 
 It turns out that it's possible to decrypt the ciphertexts provided by
 the first function. The decryption here depends on a side-channel leak by
 the decryption function. The leak is the error message that the padding is
 valid or not.

 You can find 100 web pages on how this attack works, so I won't re-explain it.
 What I'll say is this: The fundamental insight behind this attack is that the
 byte 01h is valid padding, and occur in 1/256 trials of "randomized" plaintexts
 produced by decrypting a tampered ciphertext.

 02h in isolation is not valid padding.
 02h 02h is valid padding, but is much less likely to occur randomly than 01h.
 03h 03h 03h is even less likely.

 So you can assume that if you corrupt a decryption AND it had valid padding,
 you know what that padding byte is.

 It is easy to get tripped up on the fact that CBC plaintexts are "padded".
 Padding oracles have nothing to do with the actual padding on a CBC plaintext.
 It's an attack that targets a specific bit of code that handles decryption.
 You can mount a padding oracle on any CBC block, whether it's padded or not.
 */

import Foundation

class Challenge17 {
    let BLOCK_SIZE = 16
    let key : Data = Challenge11().generateRandomKey(length: 16)
    let iv : Data = Challenge11().generateRandomKey(length: 16)

    func encrypt(plaintextInBase64: String) -> Data {
        /*
         Changed this from the Cryptopal instruction. The given 10
         strings are moved to the tests.
         */
        let fullInput = Data.from(plaintextInBase64, in: .base64)
        return Challenge10().encryptCBC(bufferedInput: fullInput, keyData: key, iv: iv)
    }
    
    func checkPad(_ ciphertext: Data) -> Bool {
        let decrypted = Challenge10().decryptCBC(bufferedInput: ciphertext, keyData: key, iv: iv)
        do {
            try Challenge15().removePad(bufferedInput: decrypted, blockSize: BLOCK_SIZE)
        } catch {
            return false
        }
        return true
    }
    
    func crack(_ cipherText: Data) throws -> String {
        let cipherBlocks = cipherText.breakIntoBlocks(ofSize: BLOCK_SIZE)
        var plainText = Data()
        var previousCipherBlock = Data(iv)  // First block uses initialization vector
        
        for currentCipherBlock in cipherBlocks {
            var currentPlainTextBlock = Data(count: BLOCK_SIZE)  // Initially all 0s
            
            for padLength in 1...BLOCK_SIZE {
                // Copy what we already know into our fake block.
                // This will copy plaintext found from end of block
                // to (padLength-1)
                var fakePreviousBlock = Data(currentPlainTextBlock)
                
                // Now XOR padding + previous block
                for k in 1...padLength {
                  fakePreviousBlock[BLOCK_SIZE - k] = fakePreviousBlock[BLOCK_SIZE - k] ^ UInt8(padLength) ^ previousCipherBlock[BLOCK_SIZE - k]
                }
                
                for guessChar in 0...255 {
                    /*
                     Finally, XOR our guess char at padLength location. Everything after this
                     location was already found and copied above from currentPlainTextBlock
                     */
                    fakePreviousBlock[BLOCK_SIZE - padLength] = fakePreviousBlock[BLOCK_SIZE - padLength] ^ UInt8(guessChar)

                    /*
                     CheckPad will first decrypt 'currentCipherBlock'. Then it will XOR
                     with 'fakePreviousBlock'. If the 'guessChar' is correct, what should
                     remain is the 'padLength'. How?
                     
                     We have created 'fakePreviousBlock' as = previousCipherBlock x padLength x guessChar
                     And the decrypted 'currentCipherBlock' is = previousCipherBlock x plainTextChar
                     
                     Now, when we XOR these two, previousCipherBlock, guessChar and plainTextChar
                     should cancel each other out (assuming guessChar == plainTextChar),
                     leaving padLength behind.
                     
                     CheckPad will try to remove to the padding. If padding is correct,
                     it won't throw an error. Which means our guess was correct.
                     */
                    if (checkPad(fakePreviousBlock + currentCipherBlock)) {
                        currentPlainTextBlock[BLOCK_SIZE-padLength] = UInt8(guessChar)
                        break  // Fount it!
                    }
                    
                    // Not found. Remove guessChar and continue to next.
                    fakePreviousBlock[BLOCK_SIZE - padLength] = fakePreviousBlock[BLOCK_SIZE - padLength] ^ UInt8(guessChar)
                    
                } // end of guessChar
            } // end of padLength
            
            plainText.append(currentPlainTextBlock)
            previousCipherBlock = currentCipherBlock
        }
        
        let decrypted = try Challenge15().removePad(bufferedInput: plainText, blockSize: BLOCK_SIZE)
        return decrypted.toString(in: .base64)
    }
    
}
