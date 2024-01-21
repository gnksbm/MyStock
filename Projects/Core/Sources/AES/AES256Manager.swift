//
//  AES256Manager.swift
//  Core
//
//  Created by gnksbm on 2024/01/04.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import CryptoSwift

public class AES256Manager {
    private static var key = ""
    private static var iv = ""
    private static var aes: AES {
        let key: [UInt8] = Array(key.utf8)
        let iv: [UInt8] = Array(iv.utf8)
        do {
            return try AES(
                key: key,
                blockMode: CBC(iv: iv),
                padding: .pkcs5
            )
        } catch {
            fatalError("Fail to init AES")
        }
    }
 
    public static func encrypt(str: String) throws -> String {
        do {
            return try aes.encrypt(str.bytes).toBase64()
        } catch {
            throw error
        }
    }
    
    public static func decrypt(encoded: String) throws -> String {
//        guard let data = Data(base64Encoded: encoded)
//        else { return "Fail to convert Data" }
        
        let bytes: [UInt8] = Array(encoded.utf8)

        do {
            let decode = try aes.decrypt(bytes)
            return String(bytes: decode, encoding: .utf8) ?? ""
        } catch {
            throw error
        }
    }
    
    public static func configAES(iv: String, key: String) {
        self.iv = iv
        self.key = key
    }
}
