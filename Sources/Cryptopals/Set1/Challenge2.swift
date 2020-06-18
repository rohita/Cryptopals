//
//  Created by Rohit Agarwal on 6/18/20.
//

import Foundation

// Fixed XOR: Write a function that takes two equal-length buffers
// and produces their XOR combination.
struct Challenge2 {

    public func fixedXor(_ hexString1: String, _ hexString2: String) -> String {
        let data1 = Data(fromHexEncodedString: hexString1)!
        let data2 = Data(fromHexEncodedString: hexString2)!
        var output = Data()
        for i in 0..<data1.count {
            output.append(data1[i] ^ data2[i])
        }
        return output.hexEncodedString()
    }
}
