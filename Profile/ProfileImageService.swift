import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    struct ProfileImageURL: Codable {
        let small: String
        let medium: String
        let large: String
        
    }
    
    struct UserResult: Codable {
        let profile_image: ProfileImageURL
        enum CodingKeys: String, CodingKey {
            case profile_image
        }
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://api.unsplash.com/users/:username")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = OAuth2TokenStorage.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                print("No data received from fetchProfileImageURL")
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                }
                return
            }
            
            do {
                        let decoder = JSONDecoder()
                        let userResult = try decoder.decode(UserResult.self, from: data)
                        DispatchQueue.main.async {
                            self.avatarURL = userResult.profile_image.small
                            completion(.success(self.avatarURL!))
                            NotificationCenter.default.post(
                                   name: ProfileImageService.DidChangeNotification,
                                   object: self,
                                   userInfo: ["URL": self.avatarURL!]
                               )
                        }
                    } catch let error {
                        print("Failed to decode UserResult: \(error)")
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
                task.resume()
            }
            
            
        }
        
        
        
        
    
    
    
    
