//
//  Created by Rohit Agarwal on 6/23/20.
//

import XCTest
@testable import Cryptopals

final class Set2Tests: XCTestCase {
    func testChallenge9() {
        let input = Data.from("YELLOW SUBMARINE", in: .cleartext)!
        let output = "YELLOW SUBMARINE\u{4}\u{4}\u{4}\u{4}"
        let output3 = "YELLOW SUBMARINE\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}"
        
        // input less than block size
        XCTAssertEqual(Challenge9().pkcs7(bufferedInput: input, blockSize: 20).toString(in: .cleartext), output)
        // input more than block size
        XCTAssertEqual(Challenge9().pkcs7(bufferedInput: input, blockSize: 10).toString(in: .cleartext), output)
        // input same as block size
        XCTAssertEqual(Challenge9().pkcs7(bufferedInput: input, blockSize: 16).toString(in: .cleartext), output3)
    }
    
    func testChallenge10_encrypt() {
        let input = Data.from("two seventy three alfredo sauce!", in: .cleartext)!
        let output = Data.from("7fd5e4aa58a5ba5ccd0f36f70ec73f91ca1478ceb2ee32b5a956ca460ee6f6eee8b17d087aadd93db6cfb9c08687e011", in: .hex)!
        let key = Data.from("KOMBUCHA IS LIFE", in: .cleartext)!
        
        let encrypted = Challenge10().encryptCBC(bufferedInput: input, keyData: key, iv: 0)
        let decrypted = Challenge10().decryptCBC(bufferedInput: output, keyData: key, iv: 0)
        
        XCTAssertEqual(encrypted.toString(in: .hex), output.toString(in: .hex))
        XCTAssertEqual(decrypted.toString(in: .cleartext), input.toString(in: .cleartext) + "\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}\u{10}")
    }
    
    func testChallenge10_decrypt() throws {
        let inputFilePath: String = "/Users/rohitagarwal/Projects/Cryptopals/Tests/CryptopalsTests/10.txt"
        let outputFilePath: String = "/Users/rohitagarwal/Projects/Cryptopals/Tests/CryptopalsTests/PlayThatFunkyMusic.txt"
        let inputFile = try String(contentsOfFile: inputFilePath)
        let outputFile = try String(contentsOfFile: outputFilePath)
        
        let bufferedInput = Data.from(inputFile, in: .base64)!
        let keyData = Data.from("YELLOW SUBMARINE", in: .cleartext)!
        
        let output = Challenge10().decryptCBC(bufferedInput: bufferedInput, keyData: keyData, iv: 0)
                
        XCTAssertEqual(output.toString(in: .cleartext), outputFile + "\u{4}\u{4}\u{4}\u{4}")
    }
    
    func testChallenge11_generateRandomKey() {
        let key1 = Challenge11().generateRandomKey(length: 16)
        let key2 = Challenge11().generateRandomKey(length: 16)
        XCTAssertNotEqual(key1.toString(in: .hex), key2.toString(in: .hex))
        XCTAssertEqual(key1.count, 16)
    }
    
    func testChallenge11_appendRandomBytes() {
        let input = Data.from("hello world", in: .cleartext)!
        let inputLength = input.count
        XCTAssertLessThan(inputLength, Challenge11().appendRandomBytes(to: input).count)
    }
    
    func testChallenge11_randomEncrypt() {
        let input = Data.from("See the line where the sky meets the sea? It calls me.", in: .cleartext)!
        let output1 = Challenge11().randomEncrypt(input)
        let output2 = Challenge11().randomEncrypt(input)
        let output3 = Challenge11().randomEncrypt(input)
        let output4 = Challenge11().randomEncrypt(input)
        XCTAssertNotEqual(output1.ciphertext, output2.ciphertext)
        XCTAssertNotEqual(output3.ciphertext, output4.ciphertext)
    }
    
    func testChallenge11_oracle() {
        let input = String(repeating: "a", count: 200) // nice identical stuff for us to find in ECB :)
        let output = Challenge11().randomEncrypt(Data.from(input, in: .cleartext)!)
        XCTAssertEqual(Challenge11().oracle(ciphertext: output.ciphertext), output.mode)
    }
}



