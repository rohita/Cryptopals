//
//  File.swift
//  
//
//  Created by Rohit Agarwal on 6/19/20.
//

import Foundation

class Challenge6 {
    
    // The Hamming distance (or edit distance) is the number of differing bits
    // between two strings
    func hammingDistance(_ input1: String, _ input2: String) -> Int {
        let bufferedInput1 = input1.data(using: .utf8)!
        let bufferedInput2 = input2.data(using: .utf8)!
        var output = 0;
        
        /*
        We take the XOR of the 2 strings. It will be 1 if
        bits are different, 0 if same. Then we add up all the 1s.
        */
        for i in 0..<bufferedInput1.count {
            let binaryString = String((bufferedInput1[i] ^ bufferedInput2[i]), radix: 2)
            binaryString.forEach { digit in output += digit.wholeNumberValue! }
        }

        return output;
    }
}
