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
    
    func testChallenge12() {
        let secretSauce = "Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkgaGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBqdXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUgYnkK"
        let output = "Rollin\' in my 5.0\nWith my rag-top down so my hair can blow\nThe girlies on standby waving just to say hi\nDid you stop? No, I just drove by\n\u{1}"
        let ecbWithSecret = Challenge12(secretSauce: Data.from(secretSauce, in: .base64)!)
        
        // should encrypt with a consistent random key
        let encrypt1 = ecbWithSecret.encryptWithSecretSauce(cleartext: "test")
        let encrypt2 = ecbWithSecret.encryptWithSecretSauce(cleartext: "test")
        XCTAssertEqual(encrypt1, encrypt2)
        
        // should determine the block size of ciphertext
        XCTAssertEqual(Challenge12.findBlockSize(encryptFunction: ecbWithSecret.encryptWithSecretSauce), 16)
        
        // should detect ECB as the mode used
        XCTAssertTrue(ecbWithSecret.detectECB())
        
        // should determine the secret sauce
        XCTAssertEqual(ecbWithSecret.crackECB(), output)
    }
    
    func testChallenge13() throws {
        let challenge13 = Challenge13()
        
        XCTAssertEqual(challenge13.sanitize(input: "foo@bar.com&role=admin"), "foo@bar.comroleadmin")
        XCTAssertEqual(challenge13.profileFor(email: "foo@bar.com"), "email=foo@bar.com&uid=10&role=user")
        
        let encodedProfile = challenge13.generateEncodedProfile(email: "foo@bar.com")
        XCTAssertEqual(encodedProfile.count, 48)
        
        let decodedProfile = try challenge13.decodeEncryptedProfile(bufferedInput: encodedProfile)
        XCTAssertEqual(decodedProfile.toString(in: .cleartext), "email=foo@bar.com&uid=10&role=user")
        
        let decodedAdminProfile = try challenge13.createAdminProfile()
        XCTAssertEqual(decodedAdminProfile.toString(in: .cleartext), "email=AAAAAAAAAAAAA&uid=10&role=admin")
    }
    
    func testChallenge15()  {
        let output = Data.from("ICE ICE BABY", in: .cleartext)!
        let pad4 = output + Data.from("\u{4}\u{4}\u{4}\u{4}", in: .cleartext)!
        let pad5 = output + Data.from("\u{5}\u{5}\u{5}\u{5}", in: .cleartext)!
        XCTAssertEqual(try Challenge15().removePad(bufferedInput: pad4, blockSize: 16), output)
        XCTAssertThrowsError(try Challenge15().removePad(bufferedInput: pad5, blockSize: 16))
    }
}

