//
//  Created by Rohit Agarwal on 6/17/20.
//

import XCTest
@testable import Cryptopals

final class Set1Tests: XCTestCase {
    func testChallange1() {
        let input = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
        let output = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
        XCTAssertEqual(Challenge1().hexToB64(input), output)
    }
    
    func testChallenge2() {
        let input1 = "1c0111001f010100061a024b53535009181c"
        let input2 = "686974207468652062756c6c277320657965"
        let output = "746865206b696420646f6e277420706c6179"
        XCTAssertEqual(Challenge2().fixedXor(input1, input2), output)
    }
}
