/*
 Implement the MT19937 Mersenne Twister RNG
 ===============================================
 You can get the psuedocode for this from Wikipedia. If you're writing in Python, Ruby,
 or (gah) PHP, your language is probably already giving you MT19937 as "rand()"; don't
 use rand(). Write the RNG yourself.
 */

import GameplayKit

@available(OSX 10.11, *)
class Challenge21 {
    let mersenne: GKMersenneTwisterRandomSource
    
    init(_ seed: UInt64) {
        mersenne = GKMersenneTwisterRandomSource(seed: seed)
    }

    func nextInt() -> Int {
        return mersenne.nextInt()
    }
}
