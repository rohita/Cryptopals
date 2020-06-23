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
    
    func testChallenge3() {
        let input = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
        let output = Challenge3().findLikelyPlaintext(input)
        XCTAssertEqual(output.decryptKey, "X")
        XCTAssertEqual(output.cleartext, "Cooking MC's like a pound of bacon")
    }
    
    func testChallenge4() throws {
        let path: String = "/Users/rohitagarwal/Projects/Cryptopals/Tests/CryptopalsTests/4.txt"
        let file = try String(contentsOfFile: path)
        let text: [String] = file.components(separatedBy: "\n")
        
        let output = Challenge4().findNeedle(haystack: text)
        XCTAssertEqual(output.ciphertext, "7b5a4215415d544115415d5015455447414c155c46155f4058455c5b523f")
        XCTAssertEqual(output.cleartext, "Now that the party is jumping\n")
    }
    
    func testChallenge5() {
        let input = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
        let output = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
        
        XCTAssertEqual(Challenge5().repeatingKeyXOR(input: input, key: "ICE"), output)        
    }
    
    func testChallenge6() throws {
        let bufferedInput1 = Data.from("this is a test", in: .cleartext)!
        let bufferedInput2 = Data.from("wokka wokka!!!", in: .cleartext)!
        XCTAssertEqual(Challenge6().hammingDistance(bufferedInput1, bufferedInput2), 37)
        
        let inputFilePath: String = "/Users/rohitagarwal/Projects/Cryptopals/Tests/CryptopalsTests/6.txt"
        let outputFilePath: String = "/Users/rohitagarwal/Projects/Cryptopals/Tests/CryptopalsTests/PlayThatFunkyMusic.txt"
        let inputFile = try String(contentsOfFile: inputFilePath)
        let outputFile = try String(contentsOfFile: outputFilePath)
        
        let output = Challenge6().crackRepeatingXOR(ciphertext: inputFile)
        XCTAssertEqual(output.decryptKey, "Terminator X: Bring the noise")
        XCTAssertEqual(output.cleartext, outputFile)
    }
    
    func testChallenge7() throws {
        let inputFilePath: String = "/Users/rohitagarwal/Projects/Cryptopals/Tests/CryptopalsTests/7.txt"
        let outputFilePath: String = "/Users/rohitagarwal/Projects/Cryptopals/Tests/CryptopalsTests/PlayThatFunkyMusic.txt"
        let inputFile = try String(contentsOfFile: inputFilePath)
        let outputFile = try String(contentsOfFile: outputFilePath)
        
        let output = Challenge7().decrypt(ciphertext: inputFile, key: "YELLOW SUBMARINE", inputEnc: .base64, keyEnc: .cleartext)!
        XCTAssertEqual(output.toString(in: .cleartext), outputFile + "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0")
    }
    
    func testChallenge8() throws {
        let inputFilePath: String = "/Users/rohitagarwal/Projects/Cryptopals/Tests/CryptopalsTests/8.txt"
        let inputFile = try String(contentsOfFile: inputFilePath)
        let text: [String] = inputFile.components(separatedBy: "\n")
        let output = "d880619740a8a19b7840a8a31c810a3d08649af70dc06f4fd5d2d69c744cd283e2dd052f6b641dbf9d11b0348542bb5708649af70dc06f4fd5d2d69c744cd2839475c9dfdbc1d46597949d9c7e82bf5a08649af70dc06f4fd5d2d69c744cd28397a93eab8d6aecd566489154789a6b0308649af70dc06f4fd5d2d69c744cd283d403180c98c8f6db1f2a3f9c4040deb0ab51b29933f2c123c58386b06fba186a"
        XCTAssertEqual(Challenge8().detectECBinArray(haystack: text).first!, output)
    }

}
