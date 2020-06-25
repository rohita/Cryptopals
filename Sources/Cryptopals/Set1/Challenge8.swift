/**
 Detect AES in ECB mode
 =========================
 
 In this file are a bunch of hex-encoded ciphertexts.

 One of them has been encrypted with ECB.

 Detect it.

 Remember that the problem with ECB is that it is stateless and deterministic; the same 16 byte plaintext block will always produce the same 16 byte ciphertext.
 */

import Foundation


class Challenge8 {
    
    func detectECBinArray(haystack: [String]) -> [String] {
        return haystack.filter { detectECB(bufferedInput: Data.from($0, in: .hex)!, blockSize: 16) }
    }
    
    func detectECB(bufferedInput: Data, blockSize: Int) -> Bool {
        
        // ECB is deterministic, so the same plaintext chunk of 16 bytes
        // would be encrypted into the same ciphertext chunk of 16 bytes.
        // We can just look for any duplicate 16 byte ciphertext chunks
        
        let chunks : [Data] = bufferedInput.breakIntoBlocks(ofSize: blockSize)
        
        var counts: [Data: Int] = [:]
        for chunk in chunks {
            counts[chunk, default: 0] += 1
        }
        
        return counts.filter { $0.value > 1 }.count > 0
    }
    
}
