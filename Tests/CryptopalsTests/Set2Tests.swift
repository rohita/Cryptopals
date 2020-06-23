//
//  Created by Rohit Agarwal on 6/23/20.
//

import XCTest
@testable import Cryptopals

final class Set2Tests: XCTestCase {
    func testChallenge9() {
        let input = "YELLOW SUBMARINE"
        let output = "YELLOW SUBMARINE\u{4}\u{4}\u{4}\u{4}"
        XCTAssertEqual(Challenge9().pkcs7(plainText: input, blockSize: 20), output)
    }
}
