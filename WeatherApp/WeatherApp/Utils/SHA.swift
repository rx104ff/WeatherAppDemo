//
//  SHA.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/19/22.
//
//  Referrence: https://stackoverflow.com/questions/25388747/sha256-in-swift

import Foundation
import CommonCrypto

struct SHA256 {
    static func hash(data : Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
}
