//
//  AES256Crypter.swift
//  Watcher
//
//  Created by Петр Первухин on 10/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import CommonCrypto
import Foundation

protocol Randomizer {
    static func randomIv() -> Data
    static func randomSalt() -> Data
    static func randomData(length: Int) -> Data
}

protocol Crypter {
    func encrypt(_ digest: Data) throws -> Data
    func decrypt(_ encrypted: Data) throws -> Data
}

///структура для шифрования AES
struct AES256Crypter {
    
    
    private var key: Data
    private var iv: Data
    
    
    public init(key: Data, iv: Data) throws {
        guard key.count == kCCKeySizeAES256 else {
            throw CryptorError.badKeyLength
        }
        guard iv.count == kCCBlockSizeAES128 else {
            throw CryptorError.badInputVectorLength
        }
        self.key = key
        self.iv = iv
    }
    
    
    enum CryptorError: Swift.Error {
        case keyGeneration(status: Int)
        case cryptoFailed(status: CCCryptorStatus)
        case badKeyLength
        case badInputVectorLength
    }
    
    
    private func crypt(input: Data, operation: CCOperation) throws -> Data {
        var outLength = Int(0)
        var outBytes = [UInt8](repeating: 0, count: input.count + kCCBlockSizeAES128)
        var status: CCCryptorStatus = CCCryptorStatus(kCCSuccess)
        input.withUnsafeBytes { (encryptedBytes: UnsafePointer<UInt8>!) -> Void in
            iv.withUnsafeBytes { (ivBytes: UnsafePointer<UInt8>!) in
                key.withUnsafeBytes { (keyBytes: UnsafePointer<UInt8>!) -> Void in
                    status = CCCrypt(operation,
                                     CCAlgorithm(kCCAlgorithmAES128),            
                        CCOptions(kCCOptionPKCS7Padding),          
                        keyBytes,                                   
                        key.count,                                
                        ivBytes,                                   
                        encryptedBytes,                           
                        input.count,                               
                        &outBytes,                                  
                        outBytes.count,                            
                        &outLength)                           
                }
            }
        }
        guard status == kCCSuccess else {
            throw CryptorError.cryptoFailed(status: status)
        }
        return Data(bytes: UnsafePointer<UInt8>(outBytes), count: outLength)
    }
    
    
    ///Метод для создания ключа для шифрования.Получается путем расширения пин-кода с помощью соли по алгоритму PBKDF2
    static func createKey(password: Data, salt: Data) throws -> Data {
        let length = kCCKeySizeAES256
        var status = Int32(0)
        var derivedBytes = [UInt8](repeating: 0, count: length)
        
        password.withUnsafeBytes { (passwordBytes: UnsafePointer<Int8>!) in
            salt.withUnsafeBytes { (saltBytes: UnsafePointer<UInt8>!) in
                status = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),              
                    passwordBytes,                                
                    password.count,                           
                    saltBytes,                                  
                    salt.count,                                  
                    CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),   
                    10000,                                        
                    &derivedBytes,                             
                    length)                                     
            }
        }
        guard status == 0 else {
            throw CryptorError.keyGeneration(status: Int(status))
        }
        return Data(bytes: UnsafePointer<UInt8>(derivedBytes), count: length)
    }
    
}

extension AES256Crypter: Crypter {
    
    ///Метод шифрования Data
    func encrypt(_ digest: Data) throws -> Data {
        return try crypt(input: digest, operation: CCOperation(kCCEncrypt))
    }
    
    
    ///Метод расшифровки Data
    func decrypt(_ encrypted: Data) throws -> Data {
        return try crypt(input: encrypted, operation: CCOperation(kCCDecrypt))
    }
    
}

extension AES256Crypter: Randomizer {
    
    ///Функция возвращает рэндомный вектор инициализации.размер вектора инициализации должен быть 16 байт (128 — бит)
    static func randomIv() -> Data {
        return randomData(length: kCCBlockSizeAES128)
    }
    
    
    ///Функция возвращает рэндомную соль
    static func randomSalt() -> Data {
        return randomData(length: 8)
    }
    
    
    ///Функциядля создания рэндомной Data
    static func randomData(length: Int) -> Data {
        var data = Data(count: length)
        let status = data.withUnsafeMutableBytes {
            CCRandomGenerateBytes($0, length)
        }
        assert(status == Int32(0))
        return data
    }
    
}
