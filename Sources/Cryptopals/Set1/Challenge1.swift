/**
Convert hex to base 64.
=======================
 
The string:

    49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d

Should produce:

    SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t

So go ahead and make that happen. You'll need to use this code for the rest of the exercises.
*/

import Foundation
 
 class Challenge1 {
    // Convert hex to base64
    
    public func hexToB64(_ hexString: String) -> String {
        let bufferedInput = Buffer.from(hexString, encoding: .hex)
        return bufferedInput.toString(encoding: .base64)
    }
 }
 
