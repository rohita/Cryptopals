/*
 Byte-at-a-time ECB decryption (Harder)
 ========================================
 
 Take your oracle function from #12. Now generate a random count of random
 bytes and prepend this string to every plaintext. You are now doing:

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
    
    func encrypt(cleartext: String) -> Data {
        let bufferedInput = Data.from(cleartext, in: .cleartext)
        let fullInput = randomPrePad + bufferedInput + secretSauce
        return Challenge7().encryptECB(plainData: fullInput, keyData: key)!
    }
    
    /************** Get Cracking ********************************/
    
    func findFirstDupedBlock(bufferedInput: Data, blockSize: Int) -> Int {
        let chunks = bufferedInput.breakIntoBlocks(ofSize: blockSize)
        for i in 0..<(chunks.count-1) {
            if (chunks[i] == chunks[i+1]) {
                return i
            }
        }
        
        return -1
    }
    
    func crack() -> String {
        let blockSize = Challenge12.findBlockSize(encryptFunction: encrypt)
        
        // we need to send a 4*blocksize payload to make sure we have at least two repeating blocks
        // which we can then use as a location marker
        var markerPayload = "A".repeat(4 * blockSize)  
        var encWithMarker = encrypt(cleartext: markerPayload)   // 15pre + 64a + 28s
        
        // find the duped block
        let dupeBlockNum = findFirstDupedBlock(bufferedInput: encWithMarker, blockSize: blockSize)  // second block = 1
        
        // shrink input until the dupe goes away
        // e.g it will be (15pre + 1a) + (16a) + (15a + 1s) + (27s)
        // where in second A block will have 1 bype of secret
        // that is where we are going to work, by fixing that position. 
        var dupeBlockNumMarker = dupeBlockNum
        while (dupeBlockNumMarker >= 0 && markerPayload.count >= 0) {
            markerPayload = String(markerPayload.dropLast())
            encWithMarker = encrypt(cleartext: markerPayload)
            dupeBlockNumMarker = findFirstDupedBlock(bufferedInput: encWithMarker, blockSize: blockSize)
        }
        
        let marker = markerPayload.count + 1  // 32 + 1
        let secondBlockLoc = (dupeBlockNum + 1) * blockSize // 32
        let length = encrypt(cleartext: "A".repeat(marker)).count - blockSize  
        
        return Challenge12.crackECB(startBlockLoc: secondBlockLoc,
                                    length: length,
                                    blockSize: blockSize,
                                    numberOfAs: marker,
                                    encryptFunction: encrypt)
    }
}
