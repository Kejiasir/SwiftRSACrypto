//
// Copyright (c) 2018 Arvin.Yang (https://github.com/Kejiasir/SwiftRSACrypto)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

typealias KeyPairExist = (_ keyPair: MIHKeyPair?, _ isExist: Bool) -> Void

typealias KeyPairBlock = (_ keyPair: MIHKeyPair?) -> Void

fileprivate let KeyPair = "KeyPair_Key"

enum SignType {
    case sha256
    case sha128
    case md5
}

class SwiftRSACrypto: NSObject {
    
    // MARK: - 生成秘钥对
    
    /// 生成RSA密钥对
    ///
    /// - Parameters:
    ///   - callback: 回调生成的密钥对模型，秘钥size为 1024 字节
    ///   - fileName: 归档到沙盒时设置的文件名，如果没有归档，填nil
    public class func rsa_generate_key(_ callback: KeyPairExist, archiverFileName fileName: String?) -> Void {
        self.rsa_generate_key(callback, ofKeySize: .key1024, archiverFileName: fileName)
    }
    
    /// 生成RSA密钥对
    ///
    /// - Parameters:
    ///   - callback: 回调生成的密钥对模型
    ///   - keySize: 枚举，可指定生成的秘钥大小
    ///   - fileName: 归档到沙盒时设置的文件名，如果没有归档，填nil
    public class func rsa_generate_key(_ callback: KeyPairExist, ofKeySize keySize: MIHRSAKeySize, archiverFileName fileName: String?) -> Void {
        let keyFactory = MIHRSAKeyFactory()
        keyFactory.preferedKeySize = keySize
        let isExist = isExistFileWithName(fileName)
        callback(!isExist ? keyFactory.generateKeyPair() : nil, isExist)
    }
    
    
    // MARK: - 私钥加密，公钥解密
    
    /// 私钥加密
    ///
    /// - Parameters:
    ///   - keyPair: 密钥对模型
    ///   - dataStr: 需加密的字符串
    /// - Returns: 返回加密后的密文字符串
    public class func privateEncrypt(_ keyPair: MIHKeyPair, encryptStr dataStr: String) -> String? {
        if let data = dataStr.data(using: .utf8) {
            if let p = keyPair.private {
                if let encryptData = try? p.encrypt(data) {
                    return dataToStr(GTMBase64.encode(encryptData))
                }
            }
        }; return nil
    }
    
    /// 公钥解密
    ///
    /// - Parameters:
    ///   - keyPair: 密钥对模型
    ///   - dataStr: 需解密的密文字符串
    /// - Returns: 返回解密后的原文字符串
    public class func publicDecrypt(_ keyPair: MIHKeyPair, decryptStr dataStr: String) -> String? {
        if let data = GTMBase64.decode(strToData(dataStr)) {
            if let p = keyPair.public { 
                if let decryptData = try? p.decrypt(data) {
                    return dataToStr(decryptData)
                }
            }
        }; return nil
    }
    
    
    // MARK: - 公钥加密，私钥解密
    
    /// 公钥加密
    ///
    /// - Parameters:
    ///   - keyPair: 密钥对模型
    ///   - dataStr: 需加密的字符串
    /// - Returns: 返回加密后的密文字符串
    public class func publicEncrypt(_ keyPair: MIHKeyPair, encryptStr dataStr: String) -> String? {
        if let data = dataStr.data(using: .utf8) {
            if let p = keyPair.public {
                if let encryptData = try? p.encrypt(data) {
                    return dataToStr(GTMBase64.encode(encryptData))
                }
            }
        }; return nil
    }
    
    /// 私钥解密
    ///
    /// - Parameters:
    ///   - keyPair: 密钥对模型
    ///   - dataStr: 需解密的密文字符串
    /// - Returns: 返回解密后的原文字符串
    public class func privateDecrypt(_ keyPair: MIHKeyPair, decryptStr dataStr: String) -> String? {
        if let data = GTMBase64.decode(strToData(dataStr)) {
            if let p = keyPair.private {
                if let decryptData = try? p.decrypt(data) {
                    return dataToStr(decryptData)
                }
            }
        }; return nil
    }
    
    
    // MARK: - 归档&&解档->沙盒
    
    /// 归档 MIHKeyPair 模型到沙盒中
    ///
    /// - Parameters:
    ///   - keyPair: 密钥对模型
    ///   - name: 归档到沙盒的文件名，带后缀，例如："keyPair.archiver"
    /// - Returns: 返回归档结果，成功返回 true，否则 false
    public class func archiverKeyPair(_ keyPair: MIHKeyPair, fileName name: String) -> Bool {
        guard let path = documentsDir() else { return false }
        let filePath = (path as NSString).appendingPathComponent(name)
        return NSKeyedArchiver.archiveRootObject(keyPair, toFile: filePath)
    }
    
    /// 从沙盒中解档 MIHKeyPair 模型
    ///
    /// - Parameters:
    ///   - callback: 通过闭包回调解档出来的密钥对模型
    ///   - name: 归档时设置的文件名，根据文件名取出归档的数据，不能为 nil
    public class func unarchiverKeyPair(_ callback: KeyPairBlock, fileName name: String) -> Void {
        guard let path = documentsDir() else { return }
        let filePath = (path as NSString).appendingPathComponent(name)
        callback(NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? MIHKeyPair)
    }
    
    
    // MARK: - 存储&&读取->偏好设置
    
    /// 存储 MIHKeyPair 模型到偏好设置
    ///
    /// - Parameter keyPair: 需要存储的密钥对模型
    public class func archiverKeyPair(_ keyPair: MIHKeyPair) -> Void {
        let data = NSKeyedArchiver.archivedData(withRootObject: keyPair)
        UserDefaults.standard.set(data, forKey: KeyPair)
    }
    
    /// 从偏好设置中读取 MIHKeyPair 模型
    ///
    /// - Parameter callback: 通过闭包回调读取的密钥对模型
    public class func unarchiverKeyPair(_ callback: KeyPairBlock) -> Void {
        let data = UserDefaults.standard.object(forKey: KeyPair) as! Data
        callback(NSKeyedUnarchiver.unarchiveObject(with: data) as? MIHKeyPair)
    }
    
    
    // MARK: - 文件操作
    
    /// 判断偏好设置中是否已存在 MIHKeyPair 模型
    ///
    /// - Returns: 如果有返回 true，否则返回 false
    public class func isExistFileWithUserDefaults() -> Bool {
        return (UserDefaults.standard.object(forKey: KeyPair) != nil) ? true : false
    }
    
    /// 从偏好设置中删除 MIHKeyPair 模型
    ///
    /// - Returns: 删除成功返回 true，否则返回 false
    public class func removeFileFromUserDefaults() -> Bool {
        UserDefaults.standard.removeObject(forKey: KeyPair)
        return !self.isExistFileWithUserDefaults()
    }
    
    /// 从沙盒中删除文件 (MIHKeyPair 模型)
    ///
    /// - Parameter fileName: 归档到沙盒时设置的文件名
    /// - Returns: 删除成功返回 true，否则返回 false
    public class func removeFileFromDocumentsDir(fileName: String) -> Bool {
        guard let path = documentsDir() else { return false }
        return ((try? FileManager.default.removeItem(atPath: path)) != nil)
    }
    
    
    // MARK: - 获取密钥对字符串
    
    /// 获取Base64编码后的公钥字符串
    ///
    /// MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC6COFOj5b0xkSkrC+KnB7gIOAEQ7m9Cp+MURDay7hJYU/c0Huyc0u8RyqHG0DtM0gnaAeuYuqGWZSAMc3GPV3EgkUkjCtH5S0gDBkJjm60S38i0GfehBfZjTwc431pvcDdiyHHn9MhBZuGIpTRyH/9/jn6HFu0BYaPajR1M0FcAQIDAQAB
    ///
    /// - Parameter keyPair: 密钥对模型
    /// - Returns: 返回公钥字符串
    public class func getPublicKey(_ keyPair: MIHKeyPair) -> String? {
        if let p = keyPair.public {
            if let data = p.dataValue() {
                return dataToStr(GTMBase64.encode(data))
            }
        }
        return nil
    }
    
    /// 获取Base64编码后的私钥字符串
    ///
    /// MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALoI4U6PlvTGRKSsL4qcHuAg4ARDub0Kn4xRENrLuElhT9zQe7JzS7xHKocbQO0zSCdoB65i6oZZlIAxzcY9XcSCRSSMK0flLSAMGQmObrRLfyLQZ96EF9mNPBzjfWm9wN2LIcef0yEFm4YilNHIf/3+OfocW7QFho9qNHUzQVwBAgMBAAECgYAeRte0W3Yr/CCr1EIgguwbef47c3JFK/dvdLoTgdhKSQYgX+Xh0xXeXI61UmAsuo3hq/KkFQEqQGYEvxZITzB1RYm61KtJKoG390hBUINnQnNTpSy+DhzQqPE4o098sRVEqRITdLhO/mDGlPSmRCrV6zjlzFcOjjyT0GhbekrGAQJBAPA1dnI78hmRPeQc8oTfPQemdtavXI9/lrXRaKlKsRtwaH2hzqxz1qbbyEX3oenxgV345vwKgcLLbj0itFeQqVECQQDGQ7TcM0NqSR1qdqziX2uakt+Exq/fsUzU+LT7jRxe3vv7JSNdwKXAWDlhQ8as2Ndl9X5V0es7sgH/mzyYJNuxAkAmobKG9LUe/4jgovct/2klTdRW+qT8PxzR6PfYIjcRnqZvbhJ7EbY356jx972Gjlyr7FfZuSbdWTJFistOOenBAkEAuQ5rWvlSXHuARGYe+nCcLDwY+4LEmCOSllrJ+t38dCTnx8QjXZe6Xm06qamsYJtJefaJhCsayK5fJSjNhykoEQJBAJj6v1sQcx/T8xFV0oF8SjEg01fdMij8QE02IcrNXfJUVI2H4Ksy171yK3vXyOgWSnf3SU7eFV8TEIYOSSXQQiM=
    ///
    /// - Parameter keyPair: 密钥对模型
    /// - Returns: 返回私钥字符串
    public class func getPrivateKey(_ keyPair: MIHKeyPair) -> String? {
        if let p = keyPair.private {
            if let data = p.dataValue() {
                let encodeData = GTMBase64.encode(data)
                let decodeData = GTMBase64.decode(encodeData)
                return base64EncodedFromPEMStr(dataToStr(decodeData)!)
            }
        }
        return nil
    }
    
    
    // MARK: - 获取格式化后的密钥对字符串
    
    /// 获取格式化后的公钥（即标准的 PKCS#8 格式公钥）
    ///
    ///    -----BEGIN PUBLIC KEY-----
    ///    MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC6COFOj5b0xkSkrC+KnB7gIOAE
    ///    Q7m9Cp+MURDay7hJYU/c0Huyc0u8RyqHG0DtM0gnaAeuYuqGWZSAMc3GPV3EgkUk
    ///    jCtH5S0gDBkJjm60S38i0GfehBfZjTwc431pvcDdiyHHn9MhBZuGIpTRyH/9/jn6
    ///    HFu0BYaPajR1M0FcAQIDAQAB
    ///    -----END PUBLIC KEY-----
    ///
    /// - Parameter keyPair: 密钥对模型
    /// - Returns: 返回格式化后的公钥字符串
    public class func getFormatterPublicKey(_ keyPair: MIHKeyPair) -> String? {
        guard let publicKey = self.getPublicKey(keyPair) else { return nil }
        return formatterPublicKey(publicKey)
    }
    
    /// 获取格式化后的私钥（即标准的 PKCS#1 格式私钥）
    ///
    ///    -----BEGIN RSA PRIVATE KEY-----
    ///    MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALoI4U6PlvTGRKSs
    ///    L4qcHuAg4ARDub0Kn4xRENrLuElhT9zQe7JzS7xHKocbQO0zSCdoB65i6oZZlIAx
    ///    zcY9XcSCRSSMK0flLSAMGQmObrRLfyLQZ96EF9mNPBzjfWm9wN2LIcef0yEFm4Yi
    ///    lNHIf/3+OfocW7QFho9qNHUzQVwBAgMBAAECgYAeRte0W3Yr/CCr1EIgguwbef47
    ///    c3JFK/dvdLoTgdhKSQYgX+Xh0xXeXI61UmAsuo3hq/KkFQEqQGYEvxZITzB1RYm6
    ///    1KtJKoG390hBUINnQnNTpSy+DhzQqPE4o098sRVEqRITdLhO/mDGlPSmRCrV6zjl
    ///    zFcOjjyT0GhbekrGAQJBAPA1dnI78hmRPeQc8oTfPQemdtavXI9/lrXRaKlKsRtw
    ///    aH2hzqxz1qbbyEX3oenxgV345vwKgcLLbj0itFeQqVECQQDGQ7TcM0NqSR1qdqzi
    ///    X2uakt+Exq/fsUzU+LT7jRxe3vv7JSNdwKXAWDlhQ8as2Ndl9X5V0es7sgH/mzyY
    ///    JNuxAkAmobKG9LUe/4jgovct/2klTdRW+qT8PxzR6PfYIjcRnqZvbhJ7EbY356jx
    ///    972Gjlyr7FfZuSbdWTJFistOOenBAkEAuQ5rWvlSXHuARGYe+nCcLDwY+4LEmCOS
    ///    llrJ+t38dCTnx8QjXZe6Xm06qamsYJtJefaJhCsayK5fJSjNhykoEQJBAJj6v1sQ
    ///    cx/T8xFV0oF8SjEg01fdMij8QE02IcrNXfJUVI2H4Ksy171yK3vXyOgWSnf3SU7e
    ///    FV8TEIYOSSXQQiM=
    ///    -----END RSA PRIVATE KEY-----
    ///
    /// - Parameter keyPair: 密钥对模型
    /// - Returns: 返回格式化后的私钥字符串
    public class func getFormatterPrivateKey(_ keyPair: MIHKeyPair) -> String? {
        guard let privateKey = self.getPrivateKey(keyPair) else { return nil }
        return formatterPrivateKey(privateKey)
    }
    
    
    // MARK: - 设置服务器返回的秘钥字符串
    
    /// 设置公钥和私钥，当秘钥是由服务器返回的时候，可使用此方法来获得密钥对模型
    ///
    /// - Parameters:
    ///   - callback: 通过闭包回调 MIHKeyPair 密钥对模型
    ///   - aPublicKey: 公钥字符串，须是去掉头尾和换行符等的纯公钥字符串
    ///   - aPrivateKey: 私钥字符串，须是去掉头尾和换行符等的纯私钥字符串
    public class func keyPair(_ callback: KeyPairBlock, publicKey aPublicKey: String?, privateKey aPrivateKey: String?) -> Void {
        callback(self.setPublicKey(aPublicKey, privateKey: aPrivateKey))
    }
    
    /// 设置公钥和私钥，当秘钥是由服务器返回的时候，可使用此方法来获得密钥对模型
    ///
    /// - Parameters:
    ///   - aPublicKey: 公钥字符串，须是去掉头尾和换行符等的纯公钥字符串
    ///   - aPrivateKey: 私钥字符串，须是去掉头尾和换行符等的纯私钥字符串
    /// - Returns: 返回 MIHKeyPair 密钥对模型
    public class func setPublicKey(_ aPublicKey: String?, privateKey aPrivateKey: String?) -> MIHKeyPair? {
        if aPublicKey == nil && aPrivateKey == nil {
            return nil
        }
        let keyPair = MIHKeyPair()
        if var privateKey = aPrivateKey {
            if !(privateKey.hasPrefix("-----BEGIN RSA PRIVATE KEY-----")) {
                privateKey = formatterPrivateKey(privateKey)
            }
            let privateKeyData = strToData(privateKey)
            keyPair.private = MIHRSAPrivateKey(data: privateKeyData)
        }
        if var publicKey = aPublicKey {
            if publicKey.hasPrefix("-----BEGIN PUBLIC KEY-----") {
                publicKey = base64EncodedFromPEMStr(publicKey)
            }
            let publicKeyData = GTMBase64.decode(strToData(publicKey))
            keyPair.public = MIHRSAPublicKey(data: publicKeyData)
        }
        return keyPair
    }
    
    
    // MARK: - 私钥签名
    
    /// RSA私钥签名，SHA256
    ///
    /// - Parameters:
    ///   - keyPair: 密钥对模型
    ///   - msg: 需要签名的字符串
    /// - Returns: 返回签名后的字符串
    public class func sha256_signature(_ keyPair: MIHKeyPair, message msg: String) -> String? {
        return dataToStr(GTMBase64.encode(sign(keyPair, msg, .sha256)))
    }
    
    /// RSA私钥签名，SHA128
    ///
    /// - Parameters:
    ///   - keyPair: 密钥对模型
    ///   - msg: 需要签名的字符串
    /// - Returns: 返回签名后的字符串
    public class func sha128_signature(_ keyPair: MIHKeyPair, message msg: String) -> String? {
        return dataToStr(GTMBase64.encode(sign(keyPair, msg, .sha128)))
    }
    
    /// RSA私钥签名，MD5
    ///
    /// - Parameters:
    ///   - keyPair: 密钥对模型
    ///   - msg: 需要签名的字符串
    /// - Returns: 返回签名后的字符串
    public class func md5_signature(_ keyPair: MIHKeyPair, message msg: String) -> String? {
        return dataToStr(GTMBase64.encode(sign(keyPair, msg, .md5)))
    }
    
    
    // MARK: - 公钥验签
    
    /// RSA公钥验签，SHA256
    ///
    /// - Parameters:
    ///   - keyPair: 密钥对模型
    ///   - signStr: 需要验证的签名字符串
    ///   - msg: 需要验证的消息字符串
    /// - Returns: 返回验证结果，验证通过返回 true，否则 false
    public class func verifySignature(_ keyPair: MIHKeyPair, SHA256 signStr: String, message msg: String) -> Bool {
        guard let data = GTMBase64.decode(strToData(signStr)) else { return false }
        return keyPair.public.verifySignature(withSHA256: data, message: strToData(msg))
    }
    
    /// RSA公钥验签，SHA128
    ///
    /// - Parameters:
    ///   - keyPair: 密钥对模型
    ///   - signStr: 需要验证的签名字符串
    ///   - msg: 需要验证的消息字符串
    /// - Returns: 返回验证结果，验证通过返回 true，否则 false
    public class func verifySignature(_ keyPair: MIHKeyPair, SHA128 signStr: String, message msg: String) -> Bool {
        guard let data = GTMBase64.decode(strToData(signStr)) else { return false }
        return keyPair.public.verifySignature(withSHA128: data, message: strToData(msg))
    }
    
    /// RSA公钥验签，MD5
    ///
    /// - Parameters:
    ///   - keyPair: 密钥对模型
    ///   - signStr: 需要验证的签名字符串
    ///   - msg: 需要验证的消息字符串
    /// - Returns: 返回验证结果，验证通过返回 true，否则 false
    public class func verifySignature(_ keyPair: MIHKeyPair, MD5 signStr: String, message msg: String) -> Bool {
        guard let data = GTMBase64.decode(strToData(signStr)) else { return false }
        return keyPair.public.verifySignature(withMD5: data, message: strToData(msg))
    }
    
    
    // MARK: - Private
    
    /// 私有方法
    ///
    /// - Parameters:
    ///   - keyPair: 密钥对模型
    ///   - msg: 需要签名的字符串
    ///   - type: 签名类型
    /// - Returns: 返回签名后的数据
    fileprivate class func sign(_ keyPair: MIHKeyPair, _ msg: String, _ type: SignType) -> Data? {
        if let data = msg.data(using: .utf8) {
            let signData: Data?
            switch type {
            case .sha256:
                signData = try? keyPair.private.sign(withSHA256: data)
            case .sha128:
                signData = try? keyPair.private.sign(withSHA128: data)
            case .md5:
                signData = try? keyPair.private.sign(withMD5: data)
            }
            return signData
        }; return nil
    }
    
}


// MARK: - Private Func

/** Filter secret key string header，newline，etc */
@inline(__always) fileprivate func base64EncodedFromPEMStr(_ pemStr: String) -> String {
    return pemStr.components(separatedBy: "-----")[2]
        .replacingOccurrences(of: "\r", with: "")
        .replacingOccurrences(of: "\n", with: "")
        .replacingOccurrences(of: "\t", with: "")
        .replacingOccurrences(of: " ",  with: "")
}

/** Format the public key string，splicing the header and footer */
@inline(__always) fileprivate func formatterPublicKey(_ aPublicKey: String) -> String {
    var mutableStr: String = ""
    mutableStr += "-----BEGIN PUBLIC KEY-----\n"
    var count: Int = 0
    for str in aPublicKey {
        if str == "\r" || str == "\n" {
            continue
        }
        mutableStr += "\(str)"
        count += 1
        if count == 64 {
            mutableStr += "\n"
            count = 0
        }
    }
    mutableStr += "\n-----END PUBLIC KEY-----"
    return mutableStr
}

/** Format the private key string，splicing the header and footer */
@inline(__always) fileprivate func formatterPrivateKey(_ aPrivateKey: String) -> String {
    var mutableStr: String = ""
    mutableStr += "-----BEGIN RSA PRIVATE KEY-----\n"
    var index: Int = 0, count: Int = 0
    for str in aPrivateKey {
        if str == "\r" || str == "\n" {
            index += 1
            continue
        }
        mutableStr += "\(str)"
        count += 1
        if count == 64 {
            mutableStr += "\n"
            count = 0
        }
        index += 1
    }
    mutableStr += "\n-----END RSA PRIVATE KEY-----"
    return mutableStr
}

/** Determine if a file exists in a sandbox directory */
@inline(__always) fileprivate func isExistFileWithName(_ fileName: String?) -> Bool {
    if let name = fileName, let path = documentsDir() {
        let filePath = (path as NSString).appendingPathComponent(name)
        return FileManager.default.fileExists(atPath: filePath)
    }
    return false
}

/** String conversion binary */
@inline(__always) fileprivate func strToData(_ string: String?) -> Data? {
    guard let anStr = string else { return nil }
    return anStr.data(using: .utf8)
}

/** Binary conversion string */
@inline(__always) fileprivate func dataToStr(_ data: Data?) -> String? {
    guard let anData = data else { return nil }
    return String(data: anData, encoding: .utf8)
}

/** C string conversion oc string */
@inline(__always) fileprivate func charToStr(_ cString: UnsafePointer<CChar>?) -> String? {
    guard let cStr = cString else { return nil }
    return String(cString: cStr, encoding: .utf8)
}

/** Sandbox documents path */
@inline(__always) fileprivate func documentsDir() -> String? {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
}

