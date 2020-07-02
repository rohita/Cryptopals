/**
 Implement CBC mode
 =======================
 
 CBC mode is a block cipher mode that allows us to encrypt irregularly-sized messages, despite the fact that a block cipher natively only transforms individual blocks.

 In CBC mode, each ciphertext block is added to the next plaintext block before the next call to the cipher core.

 The first plaintext block, which has no associated previous ciphertext block, is added to a "fake 0th ciphertext block" called the initialization vector, or IV.

 Implement CBC mode by hand by taking the ECB function you wrote earlier, making it encrypt instead of decrypt (verify this by decrypting whatever you encrypt to test), and using your XOR function from the previous exercise to combine them.

 The file here is intelligible (somewhat) when CBC decrypted against "YELLOW SUBMARINE" with an IV of all ASCII 0 (\x00\x00\x00 &c)
 */

import Foundation

class Challenge10 {
    
    func encryptCBC(bufferedInput: Data, keyData: Data, iv: Int) -> Data {
        let xorTarget = Data.fill(with: iv, count: 16)
        return encryptCBC(bufferedInput: bufferedInput, keyData: keyData, iv: xorTarget)
    }
    
    func encryptCBC(bufferedInput: Data, keyData: Data, iv: Data) -> Data {
        let paddedBufferedInput = Challenge9().pkcs7(bufferedInput: bufferedInput, blockSize: 16)
        var xorTarget = Data(iv)
        
        var output = Data();
        let blocks = paddedBufferedInput.breakIntoBlocks(ofSize: 16)
        for plainTextSlice in blocks {
            let currentSliceXor = Challenge2().fixedXor(plainTextSlice, xorTarget)
            let currentSliceEnc = Challenge7().encryptECB(plainData: currentSliceXor, keyData: keyData, isPadded: true)!
            output.append(currentSliceEnc)
            xorTarget = currentSliceEnc
        }
        return output
    }
    
    func decryptCBC(bufferedInput: Data, keyData: Data, iv: Int) -> Data {
        let xorTarget = Data.fill(with: iv, count: 16)
        return decryptCBC(bufferedInput: bufferedInput, keyData: keyData, iv: xorTarget)
    }
    
    func decryptCBC(bufferedInput: Data, keyData: Data, iv: Data) -> Data {
        var xorTarget = Data(iv)
        
        var output = Data();
        let blocks = bufferedInput.breakIntoBlocks(ofSize: 16)
        for ciphertextSlice in blocks {
            let currentSliceDec = Challenge7().decryptECB(cipherData: ciphertextSlice, keyData: keyData)!
            let currentSliceXor = Challenge2().fixedXor(currentSliceDec, xorTarget)
            output.append(currentSliceXor)
            xorTarget = ciphertextSlice
        }
        
        return output
        
    }
}
