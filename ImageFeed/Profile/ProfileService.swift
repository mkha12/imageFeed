import Foundation
final class ProfileService {
    
    static let shared = ProfileService()
    private(set) var profile: Profile?
 
    struct ProfileResult: Codable {
        let username: String
        let first_name: String
        let last_name: String
        let bio: String
        enum CodingKeys: String, CodingKey {
            case username
            case first_name
            case last_name
            case bio
        }
    }
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        let url = URL(string: "https://api.unsplash.com/me")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileResult):
                    let profile = Profile(
                        username: profileResult.username,
                        name: "\(profileResult.first_name) \(profileResult.last_name)",
                        loginName: "@\(profileResult.username)",
                        bio: (profileResult.bio)
                        //bio: profileResult.bio?
                    )
                    self.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
