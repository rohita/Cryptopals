/**
 Detect single-character XOR
 ============================
 
 One of the 60-character strings in this file has been encrypted by single-character XOR.

 Find it.
 */

import Foundation

class Challenge4 {
    
    func findNeedle(haystack: [String]) -> Challenge3.Decrypted {
        var plainHaystack = [Challenge3.Decrypted]();
        
        for input in haystack {
            plainHaystack.append(Challenge3().findLikelyPlaintext(input))
        }
        
        // Pick the one with highest englishness score
        return plainHaystack.max { a, b in a.englishnessScore < b.englishnessScore }!
    }
}
