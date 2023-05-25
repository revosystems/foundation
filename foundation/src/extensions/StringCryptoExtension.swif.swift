import Foundation
import CommonCrypto
import CryptoKit

extension String {
        
    public var sha512: String {
        let data = self.data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA512($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
    
    public var sha256: String {
        let data = Data(utf8)
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))

        data.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress, CC_LONG(buffer.count), &hash)
        }

        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    public var sha1 : String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    public func hmac256(_ key:String) -> String? {
        
        guard let messageData: Data = self.data(using: .utf8) else {
            return nil
        }
        let keyData = SymmetricKey(data: key.data(using: .utf8)!)
        
        let code = HMAC<SHA256>.authenticationCode(for: messageData, using: keyData)
        return Data(code).map { String(format: "%02hhx", $0) }.joined()
    }
}
