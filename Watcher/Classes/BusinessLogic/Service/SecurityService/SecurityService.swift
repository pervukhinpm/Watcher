//
//  SecurityService.swift
//  Watcher
//
//  Created by Петр Первухин on 08/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import Foundation
import KeychainSwift
import RealmSwift

protocol SecurityServiceProtocol {
    func savePinCode(_ pinCode: String)
    func isPinCodeEnabled() -> Bool
    func isBiometricEnabled() -> Bool
    func crypt(_ pinCode: String)
    func decryptWithBiometric() -> Bool
    func decrypt(_ pinCode: String) -> Bool
    func clearAll()
}


///Сервис для работы с шифрованием Data
class SecurityService: SecurityServiceProtocol {

    private let keychain = KeychainSwift()
    
    
    ///Метод для сохранения pinCode в keychain
    public func savePinCode(_ pinCode: String) {
        keychain.set(pinCode, forKey: "pinCode")
    }
    
    
    ///Проверка на сохраненные данные в keychain для pinCode авторизации
    public func isPinCodeEnabled() -> Bool {
        guard keychain.getData("accessToken") != nil else { return false }
        guard keychain.getData("salt") != nil else { return false }
        guard keychain.getData("iv") != nil else { return false }
        return true
    }
    
    
    ///Проверка на сохраненные данные в keychain для TouchID/FaceID
    public func isBiometricEnabled() -> Bool {
        guard keychain.getData("accessToken") != nil else { return false }
        guard keychain.getData("salt") != nil else { return false }
        guard keychain.getData("iv") != nil else { return false }
        guard keychain.get("pinCode") != nil else { return false }
        return true
    }
    
    
    ///Метод для шифрования токена с помощью ключа полученного из pinCode
    public func crypt(_ pinCode: String) {
        do {            
            let sourceData = TokenProvider.shared.token.data(using: .utf8)!
            let salt = AES256Crypter.randomSalt()
            let iv = AES256Crypter.randomIv()            
            let key = try AES256Crypter.createKey(password: pinCode.data(using: .utf8)!, salt: salt)
            let aes = try AES256Crypter(key: key, iv: iv)
            let encryptedData = try aes.encrypt(sourceData)
            keychain.set(encryptedData,
                        forKey: "accessToken", 
                        withAccess: KeychainSwiftAccessOptions.accessibleAlways)
            keychain.set(salt,
                         forKey: "salt",
                         withAccess: KeychainSwiftAccessOptions.accessibleAlways)
            keychain.set(iv,
                         forKey: "iv",
                         withAccess: KeychainSwiftAccessOptions.accessibleAlways)
        } catch {
            print(error)
        }
        
    }
    
    
    ///Метод для расшифровки accessToken при использовании TouchID/FaceID
    public func decryptWithBiometric() -> Bool {
        do {
            guard let encryptedData = keychain.getData("accessToken") else { return false }
            guard let pinCode = keychain.get("pinCode") else { return false }
            guard let salt = keychain.getData("salt") else { return false }
            guard let iv = keychain.getData("iv") else { return false }
            guard let pinCodeData = pinCode.data(using: .utf8) else { return false }
            let key = try AES256Crypter.createKey(password: pinCodeData, salt: salt)
            let aes = try AES256Crypter(key: key, iv: iv)
            let decryptedData = try aes.decrypt(encryptedData)
            guard let stringToken = String(data: decryptedData, encoding: .utf8) else { return false }
            TokenProvider.shared.token = stringToken
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    
    ///Метод для расшифровки accessToken при использовании pinCode
    public func decrypt(_ pinCode: String) -> Bool {
        do {
            guard let encryptedData = keychain.getData("accessToken") else { return false }
            guard let salt = keychain.getData("salt") else { return false }
            guard let iv = keychain.getData("iv") else { return false }
            let key = try AES256Crypter.createKey(password: pinCode.data(using: .utf8)!, salt: salt)
            let aes = try AES256Crypter(key: key, iv: iv)
            let decryptedData = try aes.decrypt(encryptedData)
            guard let stringToken = String(data: decryptedData, encoding: .utf8) else { return false }
            TokenProvider.shared.token = stringToken
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    
    ///Метод для очистки keyChain
    public func clearAll() {
        keychain.clear()
    }
     
}
