
import Foundation

final class OAuth2TokenStorage {
    var token: String?
    private static let tokenKey:String = "BearerToken"
    
    static var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
//final class OAuth2TokenStorage {
//    private let tokenKey = "BearerToken"
//    var token: String? {
//        get {
//            return UserDefaults.standard.string(forKey: tokenKey)
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: tokenKey)
//        }
//    }
//}
//let tokenStorage = OAuth2TokenStorage()
//let token = tokenStorage.token
//tokenStorage.token = "newToken"
