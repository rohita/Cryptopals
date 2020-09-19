import XCTest
@testable import Cryptopals

final class Set3Tests: XCTestCase {
    func testChallenge17() throws {
        let plaintexts = [
            "MDAwMDAwTm93IHRoYXQgdGhlIHBhcnR5IGlzIGp1bXBpbmc=",
            "MDAwMDAxV2l0aCB0aGUgYmFzcyBraWNrZWQgaW4gYW5kIHRoZSBWZWdhJ3MgYXJlIHB1bXBpbic=",
            "MDAwMDAyUXVpY2sgdG8gdGhlIHBvaW50LCB0byB0aGUgcG9pbnQsIG5vIGZha2luZw==",
            "MDAwMDAzQ29va2luZyBNQydzIGxpa2UgYSBwb3VuZCBvZiBiYWNvbg==",
            "MDAwMDA0QnVybmluZyAnZW0sIGlmIHlvdSBhaW4ndCBxdWljayBhbmQgbmltYmxl",
            "MDAwMDA1SSBnbyBjcmF6eSB3aGVuIEkgaGVhciBhIGN5bWJhbA==",
            "MDAwMDA2QW5kIGEgaGlnaCBoYXQgd2l0aCBhIHNvdXBlZCB1cCB0ZW1wbw==",
            "MDAwMDA3SSdtIG9uIGEgcm9sbCwgaXQncyB0aW1lIHRvIGdvIHNvbG8=",
            "MDAwMDA4b2xsaW4nIGluIG15IGZpdmUgcG9pbnQgb2g=",
            "MDAwMDA5aXRoIG15IHJhZy10b3AgZG93biBzbyBteSBoYWlyIGNhbiBibG93",
        ]
        let seventeen = Challenge17()
        
        for plaintext in plaintexts {
            let cipherText = seventeen.encrypt(plaintextInBase64: plaintext)
            XCTAssertEqual(try seventeen.crack(cipherText), plaintext)
        }
    }
    
    func testChallenge18_incrementLittleEndian() {
        XCTAssertEqual(Challenge18().incrementLittleEndian(Data.from("ffffffff", in: .hex)), Data.from("00000000", in: .hex))
        XCTAssertEqual(Challenge18().incrementLittleEndian(Data.from("00ffffff", in: .hex)), Data.from("01ffffff", in: .hex))
        XCTAssertEqual(Challenge18().incrementLittleEndian(Data.from("ff02030405060708", in: .hex)), Data.from("0003030405060708", in: .hex))
    }
    
    func testChallenge18_decrypt() {
        let input = Data.from("L77na/nrFsKvynd6HzOoG7GHTLXsTVu9qvY/2syLXzhPweyyMTJULu/6/kXX0KSvoOLSFQ==", in: .base64)
        let nonce = Data.fill(with: 0, count: 8)
        let key = Data.from("YELLOW SUBMARINE", in: .cleartext)
        let ouput = "Yo, VIP Let's kick it Ice, Ice, baby Ice, Ice, baby "
        
        XCTAssertEqual(Challenge18().decryptCTR(bufferedInput: input, keyData: key, nonce: nonce).toString(in: .cleartext), ouput)
    }
    
    func testChallenge19() throws {
        let path: String = "/Users/rohitagarwal/Projects/Cryptopals/Tests/CryptopalsTests/19.txt"
        let file = try String(contentsOfFile: path)
        let plaintexts: [String] = file.components(separatedBy: "\n")
        let c19 = Challenge19(plaintexts)
        
        //c19.execute(guess: "The", against: 0)
        //c19.execute(guess: "I h", against: 0)
        //c19.execute(guess: "I have", against: 0)
        //c19.execute(guess: "A terrible", against: 15)
        //c19.execute(guess: "So sensitive", against: 28)
        //c19.execute(guess: "Being certain ", against: 12)
        //c19.execute(guess: "Eighteenth-century ", against: 3)
        //c19.execute(guess: "When young and beautiful", against: 21)
        //c19.execute(guess: "This man had kept a school", against: 23)
        //c19.execute(guess: "Until her voice grew shrill", against: 19)
        //c19.execute(guess: "To some who are near my heart", against: 33)
        //c19.execute(guess: "This other his helper and friend", against: 25)
        //c19.execute(guess: "He might have won fame in the end", against: 27)
        //c19.execute(guess: "I have passed with a nod of the head", against: 4)
        c19.execute(guess: "He, too, has been changed in his turn", against: 37)
    }
    
    func testChallenge20() throws {
        let path: String = "/Users/rohitagarwal/Projects/Cryptopals/Tests/CryptopalsTests/20.txt"
        let file = try String(contentsOfFile: path)
        let plaintexts: [String] = file.components(separatedBy: "\n")
        let key : Data = Challenge11().generateRandomKey(length: 16)
        let nonce = Data.fill(with: 0, count: 8)
        
        var tempCiphers = [Data]();
        
        for input in plaintexts {
            let inputData = Data.from(input, in: .base64)
            if (inputData.count == 0) {
                continue
            }
            tempCiphers.append(Challenge18().encryptCTR(bufferedInput: inputData, keyData: key, nonce: nonce))
        }
        
        let output = Challenge20().crackFixedNonceCTR(ciphertexts: tempCiphers)
        for i in 0..<tempCiphers.count {
            XCTAssertTrue(Data.from(plaintexts[i], in: .base64).toString(in: .cleartext).starts(with: output[i]))
        }
    }
    
    @available(OSX 10.11, *)
    func testChallenge21() {
        let c21 = Challenge21(12345678)
        XCTAssertEqual(c21.mt19937(), 1731800243)
        XCTAssertEqual(c21.mt19937(), -79738025)
        XCTAssertEqual(c21.mt19937(), 1449014807)
    }
}
