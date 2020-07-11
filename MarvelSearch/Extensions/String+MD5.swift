//
//  File.swift
//  MarvelSearch
//
//  Created by Alexander Grishin on 10.07.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    
    func md5() -> String {
        let data = Data(utf8) as NSData
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(data.bytes, CC_LONG(data.length), &hash)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
