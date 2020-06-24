/**
 AES in ECB mode
 ============================
 
 The Base64-encoded content in this file has been encrypted via AES-128 in ECB mode under the key

     "YELLOW SUBMARINE".
 
 (case-sensitive, without the quotes; exactly 16 characters; I like "YELLOW SUBMARINE" because it's exactly 16 bytes long, and now you do too).

 Decrypt it. You know the key, after all.
 
 You can obviously decrypt this using the OpenSSL command-line tool, but we're having you get ECB working in code for a reason. You'll need it a lot later on, and not just for attacking ECB.
 
 Swift Ref: https://riptutorial.com/swift/example/27054/aes-encryption-in-ecb-mode-with-pkcs7-padding
 */

import Foundation
import CommonCrypto

class Challenge7 {
    func encryptECB(plainData: Data, keyData: Data, isPadded: Bool = false) -> Data? {
        let operation: CCOperation = UInt32(kCCEncrypt)
        let options:   CCOptions   = isPadded ? UInt32(kCCOptionECBMode) : UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding)
        return callCCCrypt(inputData: plainData, keyData: keyData, operation: operation, options: options)
    }
    
    func decryptECB(cipherData: Data, keyData: Data) -> Data? {
        let operation: CCOperation = UInt32(kCCDecrypt)
        let options:   CCOptions   = UInt32(kCCOptionECBMode)
        return callCCCrypt(inputData: cipherData, keyData: keyData, operation: operation, options: options)
    }
    
    /*
    Ref: https://opensource.apple.com/source/CommonCrypto/CommonCrypto-36064/CommonCrypto/CommonCryptor.h
     
    func CCCrypt(
     _ op: CCOperation,        // Defines the basic operation: kCCEncrypt or kCCDecrypt.
     _ alg: CCAlgorithm,       // Defines the encryption algorithm.
     _ options: CCOptions,     // A word of flags defining options.
     _ key: UnsafeRawPointer!,  // Raw key material
     _ keyLength: Int,          // Length of key material. Must be appropriate for the select algorithm.
     _ iv: UnsafeRawPointer!,   // Initialization vector, optional. Used for Cipher Block Chaining (CBC) mode.
                                // If present, must be the same length as the selected algorithm's block size.
                                // If CBC mode is selected (by the absence of any mode bits in the options flags)
                                // and no IV is present, a NULL (all zeroes) IV will be used. This is ignored if
                                // ECB mode is used or if a stream cipher algorithm is selected. For sound encryption,
                                // always initialize IV with random data.
     _ dataIn: UnsafeRawPointer!,               // Data to encrypt or decrypt
     _ dataInLength: Int,                       // Length of data to encrypt or decrypt.
     _ dataOut: UnsafeMutableRawPointer!,       // Result is written here. Allocated by caller. Encryption and decryption
                                                // can be performed "in-place", with the same buffer used for input and output.
     _ dataOutAvailable: Int,                   // The size of the dataOut buffer in bytes.
     _ dataOutMoved: UnsafeMutablePointer<Int>! // On successful return, the number of bytes written to dataOut.
                                                // If kCCBufferTooSmall is returned as a result of insufficient
                                                // buffer space being provided, the required buffer space is returned here.
     ) -> CCCryptorStatus
    */
    private func callCCCrypt(inputData: Data, keyData: Data, operation: CCOperation, options: CCOptions) -> Data? {
        let inputNSData : NSData = inputData as NSData
        let keyNSData : NSData = keyData as NSData
        let outputData      = NSMutableData(length: Int(inputNSData.length) + kCCBlockSizeAES128)!

        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
        let keyLength: Int         = kCCKeySizeAES128
        var numBytesEncrypted      = 0
        
        let cryptStatus: CCCryptorStatus = CCCrypt(
            operation,
            algoritm,
            options,
            keyNSData.bytes,
            keyLength,
            nil,
            inputNSData.bytes,
            inputNSData.length,
            outputData.mutableBytes,
            outputData.length,
            &numBytesEncrypted)
        
        if cryptStatus == kCCSuccess {
            return outputData.subdata(with: NSRange.init(location: 0, length: numBytesEncrypted))
        }
        
        // else throws
        print("ERROR: CCCryptorStatus=(\(cryptStatus))")
        return nil
    }
}



