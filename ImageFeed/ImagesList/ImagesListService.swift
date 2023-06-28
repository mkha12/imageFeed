import Foundation
import UIKit

final class ImagesListService {
    
    var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var currentTask: URLSessionDataTask?
    
    
    func fetchPhotosNextPage(
        completion: @escaping (Result<[Photo], Error>) -> Void) {
            let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
            guard let url = URL(string: "https://api.unsplash.com/photos?page=\(nextPage)") else {
                return
            }
            var request = URLRequest(url:url)
            if let currentTask = currentTask, currentTask.state == .running {
                return
            }
            if let token = OAuth2TokenStorage.token {
                        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    }
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let photoResults = try decoder.decode([PhotoResult].self, from: data)
                            
                    let photos = photoResults.map {
                        Photo(
                            id: $0.id,
                            size: CGSize(width: $0.width, height: $0.height),
                            createdAt: $0.createdAt,
                            welcomeDescription: $0.description,
                            thumbImageURL: $0.urls.thumb,
                            largeImageURL: $0.urls.full,
                            fullImageUrl: $0.urls.full,
                            isLiked: $0.likedByUser
                        )
                    }
                    DispatchQueue.main.async {
                        self.photos += photos
                                    NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: nil)
                                    completion(.success(photos))
                                }
        
                }
                catch {
                    print("Ошибка декодирования: \(error)")
                }
                self.currentTask = nil
            }
            task.resume()
            currentTask = task
        }
}
    
    
    struct PhotoResult: Codable {
        let id: String
        let createdAt: String
        let updatedAt: String
        let width: Int
        let height: Int
        let color: String
        let blurHash: String
        let likes: Int
        let likedByUser: Bool
        let description: String?
        let urls: UrlsResult
        
        enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case width
            case height
            case color
            case blurHash = "blur_ hash"
            case likes
            case likedByUser = "liked_by_user"
            case description
            case urls
        }
    }

    struct UrlsResult: Codable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
    struct Photo {
        let id: String
        let size: CGSize
        let createdAt: String?
        let welcomeDescription: String?
        let thumbImageURL: String
        let largeImageURL: String
        let fullImageUrl: String
        let isLiked: Bool
    }


