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
}
