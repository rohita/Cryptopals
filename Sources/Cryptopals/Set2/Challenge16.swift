/*
 CBC bitflipping attacks
 ==========================
 
 Generate a random AES key.

 Combine your padding code and CBC code to write two functions.

 The first function should take an arbitrary input string, prepend the string:

     "comment1=cooking%20MCs;userdata="
 
 .. and append the string:

     ";comment2=%20like%20a%20pound%20of%20bacon"
 
 The function should quote out the ";" and "=" characters.

 The function should then pad out the input to the 16-byte AES block length
 and encrypt it under the random AES key.

 The second function should decrypt the string and look for the characters
 ";admin=true;" (or, equivalently, decrypt, split the string on ";", convert
 each resulting string into 2-tuples, and look for the "admin" tuple).

 Return true or false based on whether the string exists.

 If you've written the first function properly, it should not be possible to
 provide user input to it that will generate the string the second function
 is looking for. We'll have to break the crypto to do that.

 Instead, modify the ciphertext (without knowledge of the AES key) to accomplish this.

 You're relying on the fact that in CBC mode, a 1-bit error in a ciphertext block:
 - Completely scrambles the block the error occurs in
 - Produces the identical 1-bit error(/edit) in the next ciphertext block.
 */

import Foundation

class Challenge16 {
    let key : Data = Challenge11().generateRandomKey(length: 16)
    let iv : Data = Challenge11().generateRandomKey(length: 16)
    
    func sanitize(_ input: String) -> String {
        return input.replacingOccurrences(of: "[;=]", with: "", options: .regularExpression, range: nil) // Eat them
    }
    
    func encrypt(cleartext: String) -> Data {
        let prepend = Data.from("comment1=cooking MCs;userdata=".uriEncode(), in: .cleartext)
        let append = Data.from(";comment2= like a pound of bacon".uriEncode(), in: .cleartext)
        let cleanInput = Data.from(sanitize(cleartext).uriEncode(), in: .cleartext)
        
        let fullInput = prepend + cleanInput + append
        
        return Challenge10().encryptCBC(bufferedInput: fullInput, keyData: key, iv: iv)
    }
    
    func decrypt(_ bufferedInput: Data) throws -> String {
        let decrypted = Challenge10().decryptCBC(bufferedInput: bufferedInput, keyData: key, iv: iv)
        return try Challenge15().removePad(bufferedInput: decrypted, blockSize: 16).toString(in: .cleartext)
    }
    
    func checkAdmin(_ bufferedInput: Data) throws -> Bool {
        let plain = try decrypt(bufferedInput)
        let profile = plain.split(separator: ";")
        let profileDict = profile.reduce(into: [Substring: Substring]()) {
            let split = $1.split(separator: "=")
            $0[split[0]] = split[1]
        }
        
        return profileDict["admin", default: "false"] == "true"
    }
    
    /****************************Get Cracking ****************************************/
    func makeAdmin() -> Data {
        // Because comment1=cooking%20MCs;userdata= is 32 bytes long, our input begins at block 3 always
        // We need to get ;admin=true in my block
        // We know that block 2 will be xor'd with block 3
        // Block 2 is %20MCs;userdata=
        // A = block 2 char
        // X = plaintext we enter
        // Z = letter we want
        // set A to AxXxZ
        var payload = encrypt(cleartext: "A".repeat(16))   // A | A ^ X
        let adminPayload = Data.from(";admin=true", in: .cleartext)  // Z
        
        for i in 0..<adminPayload.count {
            // I want the last 11 chars of my block to be my admin payload
            // like this comment1=...;userdata=AAAAA;admin=true;comment2=...
            // so starting at 48 - 11 = 37
            // and I need to edit the 2nd block to make changes to the 3rd so 37 - 16 = 21
            // 65 is my plaintext (always an A)
            payload[21 + i] = payload[21 + i] ^ 65 ^ adminPayload[i]  // A ^ X ^ Z | A ^ X
        }
        
        // comment1=cooking�-�-��jd�-ImaAAAAA;admin=true;comment2=%20like%20a%20pound%20of%20bacon
        // notice block 2 is currupted because of A ^ X ^ Z, but block 3 becomes = (A ^ X) ^ (A ^ X ^ Z) = Z
        return payload
    }
}
