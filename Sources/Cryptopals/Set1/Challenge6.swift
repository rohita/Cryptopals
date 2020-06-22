/**
 Break repeating-key XOR
 =========================
 
 There's a file here. It's been base64'd after being encrypted with repeating-key XOR.

 Decrypt it.
 
 Here's how:
 
 1. Write a function to compute the edit distance/Hamming distance between two strings. The Hamming distance is just the number of differing bits.
 2. Let KEYSIZE be the guessed length of the key; try values from 2 to (say) 40.
 3. For each KEYSIZE, take the first KEYSIZE worth of bytes, and the second KEYSIZE worth of bytes, and find the edit distance between them. Normalize this result by dividing by KEYSIZE.
 4. Take 4 KEYSIZE blocks instead of 2 and average the distances. The KEYSIZE with the smallest average normalized edit distance is probably the key. You could proceed perhaps with the smallest 2-3 KEYSIZE values.
 5. Now that you probably know the KEYSIZE: break the ciphertext into blocks of KEYSIZE length.
 6. Now transpose the blocks: make a block that is the first byte of every block, and a block that is the second byte of every block, and so on.
 7. Solve each block as if it was single-character XOR. You already have code to do this.
 8. For each block, the single-byte XOR key that produces the best looking histogram is the repeating-key XOR key byte for that block. Put them together and you have the key.
 
 This code is going to turn out to be surprisingly useful later on. Breaking repeating-key XOR ("Vigenere") statistically is obviously an academic exercise, a "Crypto 101" thing. But more people "know how" to break it than can *actually break it*, and a similar technique breaks something much more important.
 */

import Foundation

class Challenge6 {
    
    // The Hamming distance (or edit distance) is the number of differing bits
    // between two strings
    func hammingDistance(_ bufferedInput1: Data, _ bufferedInput2: Data) -> Int {
        /*
        We take the XOR of the 2 strings. It will be 1 if
        bits are different, 0 if same. Then we add up all the 1s.
        */
        var output = 0;
        for i in 0..<bufferedInput1.count {
            let binaryString = String((bufferedInput1[i] ^ bufferedInput2[i]), radix: 2)
            binaryString.forEach { digit in output += digit.wholeNumberValue! }
        }

        return output;
    }
    
    func guessKeySize(bufferedInput: Data) -> [Int] {
        var keySizes: [Int: Double] = [:]
        for i in 2...40 { // trying KEYSIZEs from 2 to 40
            var slices = [Data]()
            for j in 0...4 { // take five slices of KEYSIZE length
                slices.append(bufferedInput.subdata(in: (j*i)..<(j*i + i)))
            }
            let hd1 : Double = Double(hammingDistance(slices[0], slices[1]) / i);
            let hd2 : Double = Double(hammingDistance(slices[1], slices[2]) / i);
            let hd3 : Double = Double(hammingDistance(slices[2], slices[3]) / i); // normalize hamming distance
            let hd4 : Double = Double(hammingDistance(slices[3], slices[4]) / i); // by dividing by KEYSIZE
            
            // average out the four slices
            keySizes[i] = (hd1 + hd2 + hd3 + hd4) / 4
        }
        
        // sort by smallest hd and return the top 3 likely KEYSIZEs
        let sortedByHammingDistance = keySizes.sorted { $0.1 < $1.1 }
        return sortedByHammingDistance.prefix(3).map { $0.0 }
    }
    
    func crackRepeatingXOR(ciphertext: String) -> Challenge3.Decrypted {
        let bufferedInput = Data.from(ciphertext, in: .base64)!
        let likelyKeysizes = guessKeySize(bufferedInput: bufferedInput)
        var possibleDecrypted = [Challenge3.Decrypted]()
        
        // for each KEYSIZE possibility
        for keysize in likelyKeysizes {
            let length = bufferedInput.count;
            var blockInput = [Data]()
            
            // break input into KEYSIZE blocks
            for startIndex in stride(from: 0, to: length, by: keysize)  {
                var block = Data(count: keysize)
                let endIndex = startIndex + keysize > length ? length : startIndex + keysize
                let rangeToCopy = startIndex..<endIndex
                
                block.replaceSubrange(0..<(rangeToCopy.count), with: bufferedInput.subdata(in: rangeToCopy))
                blockInput.append(block)
            }
            
            let transposeBlockSize = blockInput.count
            var transposedInputArr = [Data]()
            
            // transpose input into blocks of just 1st byte of each block, just 2nd etc
            for byteIndex in 0..<keysize {
                var transposed = Data(count: transposeBlockSize)
                for blockIndex in 0..<transposeBlockSize  {
                    transposed[blockIndex] = blockInput[blockIndex][byteIndex]
                }
                transposedInputArr.append(transposed)
            }
             
            // Solve each transposed block as if it was single-character XOR using Challenge3.
            var keyArr = [UInt8]();
            for ciphertext in transposedInputArr {
                let likelyPlaintext = Challenge3().findLikelyPlaintext(ciphertext)
                keyArr.append(contentsOf: likelyPlaintext.decryptKey.utf8)
            }
            
            // put all the keys together to have the finished key
            let bufferedKey = Data(keyArr)
            
            // using this key decrypt the input and get its englishness score using Challenge5
            let plaintext = Challenge5().repeatingKeyXOR(bufferedInput: bufferedInput, bufferedKey: bufferedKey).toString(in: .cleartext)
            let score = Englishness.score(input: plaintext)
            
            possibleDecrypted.append(Challenge3.Decrypted(
                ciphertext: "", // not needed
                decryptKey: bufferedKey.toString(in: .cleartext),
                cleartext: plaintext,
                englishnessScore: score))
        }
        
        // Pick the one with highest englishness score
        return possibleDecrypted.max { a, b in a.englishnessScore < b.englishnessScore }!
    }
}