import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()

    private let service = "com.moa.app"
    private let account = "jwt_token"

    // MARK: - Save Token
    func saveToken(_ token: String) {
        let tokenData = token.data(using: .utf8)!

        // Try to delete existing token first
        deleteToken()

        // Create query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: tokenData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        // Add to keychain
        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecSuccess {
            print("Token saved to Keychain successfully")
        } else {
            print("Failed to save token to Keychain: \(status)")
        }
    }

    // MARK: - Retrieve Token
    func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess,
           let data = result as? Data,
           let token = String(data: data, encoding: .utf8) {
            return token
        }

        return nil
    }

    // MARK: - Delete Token
    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        let status = SecItemDelete(query as CFDictionary)

        if status == errSecSuccess {
            print("Token deleted from Keychain successfully")
        } else if status != errSecItemNotFound {
            print("Failed to delete token from Keychain: \(status)")
        }
    }

    // MARK: - Check if Token Exists
    func hasToken() -> Bool {
        return getToken() != nil
    }
}
