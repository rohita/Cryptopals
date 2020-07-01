/**
 ECB cut-and-paste
 ===================
 
 Now write a function that encodes a user profile in that format, given an email address. You should have something like:

     profile_for("foo@bar.com")
 
 ... and it should produce:
 
     email=foo@bar.com&uid=10&role=user
 
 Your "profile_for" function should not allow encoding metacharacters (& and =). Eat them, quote them, whatever you want to do, but don't let people set their email address to "foo@bar.com&role=admin".

 Now, two more easy functions. Generate a random AES key, then:

 A. Encrypt the encoded user profile under the key; "provide" that to the "attacker".
 B. Decrypt the encoded user profile and parse it.
 
 Using only the user input to profile_for() (as an oracle to generate "valid" ciphertexts) and the ciphertexts themselves, make a role=admin profile.
 */

import Foundation

class Challenge13 {
    let key : Data = Challenge11().generateRandomKey(length: 16) // static key for testing
    
    func parseQueryString(input: String) -> [String: Any] {
        let components = input.components(separatedBy: "&")
        var output = [String: Any]()
        for pairs in components {
            let pair = pairs.components(separatedBy: "=")
            output[pair[0]] = Int(pair[1]) ?? pair[1]
        }
        return output
    }
    
    func sanitize(input: String) -> String {
        return input.replacingOccurrences(of: "[&=]", with: "", options: .regularExpression, range: nil) // Eat them
    }
    
    func profileFor(email: String) -> String {
        let sanitizedEmail = sanitize(input: email)
        return "email=\(sanitizedEmail)&uid=10&role=user"
    }
    
    func generateEncodedProfile(email: String) -> Data {
        let profile = profileFor(email: email)
        return Challenge7().encryptECB(plainData: Data.from(profile, in: .cleartext)!, keyData: key)!
    }
    
    func decodeEncryptedProfile(bufferedInput: Data) throws -> Data {
        let decodedProfile = Challenge7().decryptECB(cipherData: bufferedInput, keyData: key)!
        return try Challenge15().removePad(bufferedInput: decodedProfile, blockSize: 16)
    }
    
    /************** Get Cracking ********************************/
    
    func createAdminProfile() throws -> Data {
        // find blocksize first
        let blockSize = Challenge12.findBlockSize(encryptFunction: generateEncodedProfile)
        
        // get 'admin' plus a bunch of 11s (16-5 = 11) to make a block
        let adminDiffLength = blockSize - 5
        let pad = Data.fill(with: adminDiffLength, count: adminDiffLength)
        let adminRolePayload = "admin" + pad.toString(in: .cleartext)   // one block "admin0b0b0b0b0b0b0b0b0b0b0b"
        
        // need to position the adminRolePayload so that it gets a block of its own
        // which means email=something needs to be exactly blocksize
        let prePayloadLength = blockSize - 6 // email=
        let prePayload = "A".repeat(prePayloadLength)   // "AAAAAAAAAA"
        
        // encrypt once to get the encrypted admin payload
        let encryptedWithAdmin = generateEncodedProfile(email: prePayload + adminRolePayload)  // "email=AAAAAAAAAAadmin0b0b0b0b0b0b0b0b0b0b0b&uid..."
        
        // we need to slice out just the encrypted admin role payload section
        // which would be block 2
        let encAdminBlock = encryptedWithAdmin[blockSize..<blockSize * 2]   // "admin0b0b0b0b0b0b0b0b0b0b0b"
        
        // now we generate a profile that has the role all by itself in the last block
        // email=a&uid=XX&role=user -> 13 on the right hand side ("&uid=XX&role="),
        // 6 on the left ("email="). Need to make it add up to a multiple of the blocksize
        var pusherPayloadLength = 1
        while ((pusherPayloadLength + 19) % blockSize != 0) {
            pusherPayloadLength += 1
        }
        let pusherPayload = "A".repeat(pusherPayloadLength)   // 32 - 19 = 13
        let roleInLastBlock = generateEncodedProfile(email: pusherPayload)  // email=AAAAAAAAAAAAA&uid=10&role=user
        
        // now we just need to swap the last block with encAdminBlock
        let adminProfile = roleInLastBlock.dropLast(blockSize) + encAdminBlock
        
        // pass our new profile to the decode function
        return try decodeEncryptedProfile(bufferedInput: adminProfile)
    }
}
