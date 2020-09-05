/*
 Implement CBC mode
 =======================
 
 Cipher block chaining (CBC) mode is a block cipher mode that allows us to encrypt irregularly-sized messages,
 despite the fact that a block cipher natively only transforms individual blocks.

 In CBC mode, each ciphertext block is added to the next plaintext block before the next call to the cipher core.
 The first plaintext block, which has no associated previous ciphertext block, is added to a "fake 0th ciphertext
 block" called the initialization vector, or IV.

 Implement CBC mode by hand by taking the ECB function you wrote earlier, making it encrypt instead of decrypt
 (verify this by decrypting whatever you encrypt to test), and using your XOR function from the previous exercise
 to combine them.

 The file here is intelligible (somewhat) when CBC decrypted against "YELLOW SUBMARINE" with an IV of all
 ASCII 0 (\x00\x00\x00 &c)
 
 https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation
 */

import Foundation

class Challenge10 {
    
    func encryptCBC(bufferedInput: Data, keyData: Data, iv: Int) -> Data {
        let xorTarget = Data.fill(with: iv, count: 16)
        return encryptCBC(bufferedInput: bufferedInput, keyData: keyData, iv: xorTarget)
    }
    
    func encryptCBC(bufferedInput: Data, keyData: Data, iv: Data) -> Data {
        let paddedBufferedInput = Challenge9().pkcs7(bufferedInput: bufferedInput, blockSize: 16)
        let blocks = paddedBufferedInput.breakIntoBlocks(ofSize: 16)
        
        /*
         In CBC mode, each block of plaintext is XORed with the previous ciphertext block before being encrypted.
         This way, each ciphertext block depends on all plaintext blocks processed up to that point. The first
         plaintext block has no associated previous ciphertext block. So an initialization vector must be used
         in the first block.
         */
        var output = Data();
        var previousCipherBlock = Data(iv)   // Initialization Vector
        for currentPlainTextBlock in blocks {
            let currentXorBlock = Challenge2().fixedXor(currentPlainTextBlock, previousCipherBlock)
            let currentCipherBlock = Challenge7().encryptECB(plainData: currentXorBlock, keyData: keyData, isPadded: true)!
            output.append(currentCipherBlock)
            previousCipherBlock = currentCipherBlock
        }
        return output
    }
    
    func decryptCBC(bufferedInput: Data, keyData: Data, iv: Int) -> Data {
        let xorTarget = Data.fill(with: iv, count: 16)
        return decryptCBC(bufferedInput: bufferedInput, keyData: keyData, iv: xorTarget)
    }
    
    func decryptCBC(bufferedInput: Data, keyData: Data, iv: Data) -> Data {
        let blocks = bufferedInput.breakIntoBlocks(ofSize: 16)
        
        var output = Data();
        var previousCipherBlock = Data(iv)
        for currentCipherBlock in blocks {
            /*
             First we decrypt the block, which gives us the XOR'ed data between plaintext and previous
             ciphertext block. Then we XOR this again with previous ciphertext block, which gives us the
             plaintext block.
             */
            let currentXorBlock = Challenge7().decryptECB(cipherData: currentCipherBlock, keyData: keyData)!
            let currentPlainTextBlock = Challenge2().fixedXor(currentXorBlock, previousCipherBlock)
            output.append(currentPlainTextBlock)
            previousCipherBlock = currentCipherBlock
        }
        return output
    }
}
