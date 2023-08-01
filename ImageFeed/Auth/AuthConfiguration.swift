import Foundation

let fileAccessKey = "Kn-Jk8AOLFL95xB3HHHLnXUG8dWaz85JnIMRowyXp0I"
let fileSecretKey = "VZEQRm_XoeLDE_X6abnGtw4wB7mxSYVHg9rkqE3MmHo"
let fileRedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let fileAccessScope = "public+read_user+write_likes"
let fileDefaultBaseURL = URL(string: "https://api.unsplash.com")!


let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: fileAccessKey,
                                     secretKey: fileSecretKey,
                                     redirectURI: fileRedirectURI,
                                     accessScope: fileAccessScope,
                                     defaultBaseURL: fileDefaultBaseURL,
                                     authURLString: unsplashAuthorizeURLString)
        }
}


