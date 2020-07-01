/**
 Byte-at-a-time ECB decryption (Harder)
 ========================================
 
 Take your oracle function from #12. Now generate a random count of random bytes and prepend this string to every plaintext. You are now doing:

     AES-128-ECB(random-prefix || attacker-controlled || target-bytes, random-key)
 
 Same goal: decrypt the target-bytes.
 */

import Foundation

class Challenge14 {
    let secretSauce : Data
    let key : Data = Challenge11().generateRandomKey(length: 16) // static key for testing
    let randomPrePad : Data = Challenge11().generateRandomKey(length: Int.random(in: 8...32)) // // random length between 8 and 32
    
    init(secretSauce: Data) {
        self.secretSauce = secretSauce
    }
    
    func encrypt(bufferedInput: Data) -> Data {
        let fullInput = randomPrePad + bufferedInput + secretSauce
        return Challenge7().encryptECB(plainData: fullInput, keyData: key)!
    }
    
    /************** Get Cracking ********************************/
    
}
