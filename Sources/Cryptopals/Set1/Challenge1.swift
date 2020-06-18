//
//  Created by Rohit Agarwal on 6/17/20.
//

import Foundation
 
 struct Challenge1 {
     // Convert hex to base64
     public func hexToB64(_ hexString: String) -> String {
         let data = Data(fromHexEncodedString: hexString)!
         return data.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
     }
 }
 
