//
//  Data+Extension.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/17/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import Foundation
import CommonCrypto

extension Data {
    var md5 : String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ =  self.withUnsafeBytes { bytes in
            CC_MD5(bytes.baseAddress, CC_LONG(self.count), &digest)
        }
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }
}
