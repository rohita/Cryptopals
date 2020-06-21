/**
 Fixed XOR
 ==========
 
 Write a function that takes two equal-length buffers and produces their XOR combination.

 If your function works properly, then when you feed it the string:

     1c0111001f010100061a024b53535009181c
 
 ... after hex decoding, and when XOR'd against:

     686974207468652062756c6c277320657965
 
 ... should produce:

     746865206b696420646f6e277420706c6179
 */

import Foundation

class Challenge2 {

    public func fixedXor(_ hexString1: String, _ hexString2: String) -> String {
        let buffer = Buffer.from(hexString1, encoding: .hex)
        let output = buffer.repeatingKeyXOR(with: hexString2, encoding: .hex)
        return output.toString(encoding: .hex)
    }
}
