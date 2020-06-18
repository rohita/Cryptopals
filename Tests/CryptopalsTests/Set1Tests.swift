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
}
