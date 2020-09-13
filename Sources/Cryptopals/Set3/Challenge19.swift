/*
 Break fixed-nonce CTR mode using substitutions
 ===============================================
 
 Take your CTR encrypt/decrypt function and fix its nonce value to 0. Generate a random AES key.

 In successive encryptions (not in one big running CTR stream), encrypt each line of the base64
 decodes of the following, producing multiple independent ciphertexts: (see file 19.txt)
 (This should produce 40 short CTR-encrypted ciphertexts).

 Because the CTR nonce wasn't randomized for each encryption, each ciphertext has been encrypted
 against the same keystream. This is very bad. Understanding that, like most stream ciphers
 (including RC4, and obviously any block cipher run in CTR mode), the actual "encryption" of a byte
 of data boils down to a single XOR operation, it should be plain that:

 CIPHERTEXT-BYTE XOR PLAINTEXT-BYTE = KEYSTREAM-BYTE
 
 And since the keystream is the same for every ciphertext:

 CIPHERTEXT-BYTE XOR KEYSTREAM-BYTE = PLAINTEXT-BYTE (ie, "you don't say!")
 
 Attack this cryptosystem piecemeal: guess letters, use expected English language frequence to
 validate guesses, catch common English trigrams, and so on. Don't overthink it. Points for automating
 this, but part of the reason I'm having you do this is that I think this approach is suboptimal.
 */

import Foundation

class Challenge19 {
    let key : Data = Challenge11().generateRandomKey(length: 16)
    let nonce = Data.fill(with: 0, count: 8)
    let ciphertexts : [Data]
    let challenge2 = Challenge2()
    
    init(_ plaintexts : [String]) {
        var tempCiphers = [Data]();
        
        for input in plaintexts {
            let inputData = Data.from(input, in: .base64)
            tempCiphers.append(Challenge18().encryptCTR(bufferedInput: inputData, keyData: key, nonce: nonce))
        }
        
        ciphertexts = tempCiphers
    }

    func execute(guess: String, against: Int) {
        // The guesses are coming from the tests. See Set3Tests.swift.
        
        // Attack this cryptosystem piecemeal: guess letters, use expected English language
        // frequence to validate guesses, catch common English trigrams, and so on.
        // If (c[against] ^ guess ^ c[0..40]) looks reasonable, keep it.
        
        // CIPHERTEXT-BYTE XOR PLAINTEXT-BYTE = KEYSTREAM-BYTE
        let guessKey = xor(ciphertexts[against], guess)
        
        // CIPHERTEXT-BYTE XOR KEYSTREAM-BYTE = PLAINTEXT-BYTE
        for i in 0..<40 {
            let result = xor(ciphertexts[i], guessKey)
            print("\(i): \(result)")  // which one looks most like english text
        }
    }
    
    private func xor(_ ciphertext: Data, _ guess: String) -> Data {
        return challenge2.fixedXor(Data.from(guess, in: .cleartext), ciphertext)
    }
    
    private func xor(_ ciphertext: Data, _ testKey: Data) -> String {
        return challenge2.fixedXor(testKey, ciphertext).toString(in: .cleartext)
    }
}
