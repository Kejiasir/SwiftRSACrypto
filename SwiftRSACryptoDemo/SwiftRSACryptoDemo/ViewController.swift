//
//  ViewController.swift
//  SwiftRSACryptoDemo
//
//  Created by Yi Qing on 2018/5/16.
//  Copyright © 2018年 Arvin. All rights reserved.
//

let kPublicKey  = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC6COFOj5b0xkSkrC+KnB7gIOAEQ7m9Cp+MURDay7hJYU/c0Huyc0u8RyqHG0DtM0gnaAeuYuqGWZSAMc3GPV3EgkUkjCtH5S0gDBkJjm60S38i0GfehBfZjTwc431pvcDdiyHHn9MhBZuGIpTRyH/9/jn6HFu0BYaPajR1M0FcAQIDAQAB"

let kPrivateKey = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALoI4U6PlvTGRKSsL4qcHuAg4ARDub0Kn4xRENrLuElhT9zQe7JzS7xHKocbQO0zSCdoB65i6oZZlIAxzcY9XcSCRSSMK0flLSAMGQmObrRLfyLQZ96EF9mNPBzjfWm9wN2LIcef0yEFm4YilNHIf/3+OfocW7QFho9qNHUzQVwBAgMBAAECgYAeRte0W3Yr/CCr1EIgguwbef47c3JFK/dvdLoTgdhKSQYgX+Xh0xXeXI61UmAsuo3hq/KkFQEqQGYEvxZITzB1RYm61KtJKoG390hBUINnQnNTpSy+DhzQqPE4o098sRVEqRITdLhO/mDGlPSmRCrV6zjlzFcOjjyT0GhbekrGAQJBAPA1dnI78hmRPeQc8oTfPQemdtavXI9/lrXRaKlKsRtwaH2hzqxz1qbbyEX3oenxgV345vwKgcLLbj0itFeQqVECQQDGQ7TcM0NqSR1qdqziX2uakt+Exq/fsUzU+LT7jRxe3vv7JSNdwKXAWDlhQ8as2Ndl9X5V0es7sgH/mzyYJNuxAkAmobKG9LUe/4jgovct/2klTdRW+qT8PxzR6PfYIjcRnqZvbhJ7EbY356jx972Gjlyr7FfZuSbdWTJFistOOenBAkEAuQ5rWvlSXHuARGYe+nCcLDwY+4LEmCOSllrJ+t38dCTnx8QjXZe6Xm06qamsYJtJefaJhCsayK5fJSjNhykoEQJBAJj6v1sQcx/T8xFV0oF8SjEg01fdMij8QE02IcrNXfJUVI2H4Ksy171yK3vXyOgWSnf3SU7eFV8TEIYOSSXQQiM="

let fmPublicKey =
"""
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC6COFOj5b0xkSkrC+KnB7gIOAE
Q7m9Cp+MURDay7hJYU/c0Huyc0u8RyqHG0DtM0gnaAeuYuqGWZSAMc3GPV3EgkUk
jCtH5S0gDBkJjm60S38i0GfehBfZjTwc431pvcDdiyHHn9MhBZuGIpTRyH/9/jn6
HFu0BYaPajR1M0FcAQIDAQAB
-----END PUBLIC KEY-----
"""

let fmPrivateKey =
"""
-----BEGIN RSA PRIVATE KEY-----
MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALoI4U6PlvTGRKSs
L4qcHuAg4ARDub0Kn4xRENrLuElhT9zQe7JzS7xHKocbQO0zSCdoB65i6oZZlIAx
zcY9XcSCRSSMK0flLSAMGQmObrRLfyLQZ96EF9mNPBzjfWm9wN2LIcef0yEFm4Yi
lNHIf/3+OfocW7QFho9qNHUzQVwBAgMBAAECgYAeRte0W3Yr/CCr1EIgguwbef47
c3JFK/dvdLoTgdhKSQYgX+Xh0xXeXI61UmAsuo3hq/KkFQEqQGYEvxZITzB1RYm6
1KtJKoG390hBUINnQnNTpSy+DhzQqPE4o098sRVEqRITdLhO/mDGlPSmRCrV6zjl
zFcOjjyT0GhbekrGAQJBAPA1dnI78hmRPeQc8oTfPQemdtavXI9/lrXRaKlKsRtw
aH2hzqxz1qbbyEX3oenxgV345vwKgcLLbj0itFeQqVECQQDGQ7TcM0NqSR1qdqzi
X2uakt+Exq/fsUzU+LT7jRxe3vv7JSNdwKXAWDlhQ8as2Ndl9X5V0es7sgH/mzyY
JNuxAkAmobKG9LUe/4jgovct/2klTdRW+qT8PxzR6PfYIjcRnqZvbhJ7EbY356jx
972Gjlyr7FfZuSbdWTJFistOOenBAkEAuQ5rWvlSXHuARGYe+nCcLDwY+4LEmCOS
llrJ+t38dCTnx8QjXZe6Xm06qamsYJtJefaJhCsayK5fJSjNhykoEQJBAJj6v1sQ
cx/T8xFV0oF8SjEg01fdMij8QE02IcrNXfJUVI2H4Ksy171yK3vXyOgWSnf3SU7e
FV8TEIYOSSXQQiM=
-----END RSA PRIVATE KEY-----
"""

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad() 
    }
    
    // MARK: - 生成秘钥对
    @IBAction func create_rsa(_ sender: Any) {
        
        /// 1️⃣ 默认秘钥 size 1024
        SwiftRSACrypto.rsa_generate_key({ (keyPair, isExist) in
            print(keyPair, isExist)
            if let keyPair = keyPair {
                /// 归档 keyPair 到沙盒中
                let result = SwiftRSACrypto.archiverKeyPair(keyPair, fileName: "keyPair.archiver")
                print(result)
            }
        }, archiverFileName: "keyPair.archiver")
        
        /// 2️⃣ 指定秘钥 size 512
        SwiftRSACrypto.rsa_generate_key({ (keyPair, isExist) in
            print(keyPair, isExist)
            if let keyPair = keyPair {
                /// 存储 keyPair 到偏好设置
                SwiftRSACrypto.archiverKeyPair(keyPair)
            }
        }, ofKeySize: .key512, archiverFileName: nil)
        
    }
    
    // MARK: - 公钥加密 -> 私钥解密
    @IBAction func publicEncrypt(_ sender: Any) {
        /// 从沙盒中解档秘钥对
        SwiftRSACrypto.unarchiverKeyPair({
            if let enStr = SwiftRSACrypto.publicEncrypt($0!, encryptStr: "我是 arvin！") {
                if let deStr = SwiftRSACrypto.privateDecrypt($0!, decryptStr: enStr) {
                    print("加密后的密文: \(enStr)")
                    print("解密后的原文: \(deStr)")
                }
            }
        }, fileName: "keyPair.archiver")
    }
    
    // MARK: - 私钥加密 -> 公钥解密
    @IBAction func privateEncrypt(_ sender: Any) {
        /// 从偏好设置中读取秘钥对
        SwiftRSACrypto.unarchiverKeyPair { (keyPair) in
            if let keyPair = keyPair {
                if let enStr = SwiftRSACrypto.privateEncrypt(keyPair, encryptStr: "arvin 是我！") {
                    if let deStr = SwiftRSACrypto.publicDecrypt(keyPair, decryptStr: enStr) {
                        print("加密后的密文: \(enStr)")
                        print("解密后的原文: \(deStr)")
                    }
                }
            }
        }
    }
    
    // MARK: - 获取秘钥对字符串
    @IBAction func getKeyPair(_ sender: Any) {
        SwiftRSACrypto.rsa_generate_key({ (keyPair, isExist) in
            if let keyPair = keyPair {
                if let pubKey = SwiftRSACrypto.getPublicKey(keyPair) {
                    print("pubKey = \n\(pubKey)")
                }
                print("\n")
                if let priKey = SwiftRSACrypto.getPrivateKey(keyPair) {
                    print("priKey = \n\(priKey)")
                }
            }
        }, archiverFileName: nil)
    }
    
    // MARK: - 获取格式化后的秘钥对字符串
    @IBAction func getFmKeyPair(_ sender: Any) {
        SwiftRSACrypto.rsa_generate_key({ (keyPair, isExist) in
            if let keyPair = keyPair {
                if let pubKey = SwiftRSACrypto.getFormatterPublicKey(keyPair) {
                    print("fmPubKey = \n\(pubKey)")
                }
                print("\n")
                if let priKey = SwiftRSACrypto.getFormatterPrivateKey(keyPair) {
                    print("fmPriKey = \n\(priKey)")
                }
            }
        }, ofKeySize: .key2048, archiverFileName: nil)
    }
    
    // MARK: - 设置服务器返回的秘钥并加解密
    @IBAction func setKey_with_servers(_ sender: Any) {
        
        /// 返回 nil
        if let keyPair = SwiftRSACrypto.setPublicKey(nil, privateKey: nil) {
            print("keyPair = \(keyPair.public)")
            print("keyPair = \(keyPair.private)")
        }
        
        print("\n")
        
        /// 返回公钥
        if let keyPair = SwiftRSACrypto.setPublicKey(kPublicKey, privateKey: nil) {
            print("keyPair = \(keyPair.public)")
            print("keyPair = \(keyPair.private)")
            /// 秘钥对中只返回了公钥，使用公钥加密
            if let enStr = SwiftRSACrypto.publicEncrypt(keyPair, encryptStr: "hello world!") {
                print("加密后的密文: \(enStr)")
            }
        }
        
        print("\n")
        
        /// 返回私钥
        SwiftRSACrypto.keyPair({
            print("$0 = \($0?.public)")
            print("$0 = \($0?.private)")
            /// 秘钥对中只返回了私钥，使用私钥加密
            if let enStr = SwiftRSACrypto.privateEncrypt($0!, encryptStr: "🇨🇳🌹🐒") {
                print("加密后的密文: \(enStr)")
            }
        }, publicKey: nil, privateKey: kPrivateKey)
        
        print("\n")
        
        /// 返回公钥私钥
        SwiftRSACrypto.keyPair({ (keyPair) in
            print(keyPair?.public)
            print(keyPair?.private)
            
            /// 公钥加密，私钥解密
            if let enStr = SwiftRSACrypto.publicEncrypt(keyPair!, encryptStr: "o(*￣︶￣*)o") {
                if let deStr = SwiftRSACrypto.privateDecrypt(keyPair!, decryptStr: enStr) {
                    print("加密后的密文: \(enStr)")
                    print("解密后的原文: \(deStr)")
                }
            }
            
            /// 私钥加密，公钥解密
            if let enStr = SwiftRSACrypto.privateEncrypt(keyPair!, encryptStr: "你好，世界！") {
                if let deStr = SwiftRSACrypto.publicDecrypt(keyPair!, decryptStr: enStr) {
                    print("加密后的密文: \(enStr)")
                    print("解密后的原文: \(deStr)")
                }
            }
        }, publicKey: fmPublicKey, privateKey: fmPrivateKey)
    }
    
    // MARK: - 私钥签名 -> 公钥验签
    @IBAction func privateSign(_ sender: Any) {
        
        SwiftRSACrypto.unarchiverKeyPair({
            /// 签名
            let sign1 = SwiftRSACrypto.SHA256_SignKeyPair($0!, message: "11111")
            let sign2 = SwiftRSACrypto.SHA128_SignKeyPair($0!, message: "22222")
            let sign3 = SwiftRSACrypto.MD5_SignKeyPair($0!, message: "33333")
            print(sign1)
            print(sign2)
            print(sign3)
            
            /// 验签
            let verStr1 = SwiftRSACrypto.verSignKeyPair($0!, SHA256: sign1!, message: "11111")
            let verStr2 = SwiftRSACrypto.verSignKeyPair($0!, SHA128: sign2!, message: "22222")
            let verStr3 = SwiftRSACrypto.verSignKeyPair($0!, MD5: sign3!, message: "33333")
            print(verStr1)
            print(verStr2)
            print(verStr3)
            
            ///  ERROR
            let errStr1 = SwiftRSACrypto.verSignKeyPair($0!, SHA256: sign1!, message: "00000")
            let errStr2 = SwiftRSACrypto.verSignKeyPair($0!, SHA128: sign3!, message: "22222")
            let errStr3 = SwiftRSACrypto.verSignKeyPair($0!, MD5: sign2!, message: "33333")
            print(errStr1)
            print(errStr2)
            print(errStr3)
            
        }, fileName: "keyPair.archiver")
        
    }
}
