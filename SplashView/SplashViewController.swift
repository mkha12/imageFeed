import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    //var profileService: ProfileService?
    private let profileService = ProfileService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        if let token = OAuth2TokenStorage.token {
              UIBlockingProgressHUD.show()
              fetchProfile(token: token)
            switchToTabBarController()
          } else {
              performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
          }
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    func fetchProfile(token: String) {
        profileService.fetchProfile(token) { result in
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}


extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    

    
    private func fetchOAuthToken(_ code: String) {
        
        //oauth2Service.fetchOAuthToken(code) { [weak self] result in
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in

            guard let self = self else { return }
            switch result {
            case .success(let authToken):
                UIBlockingProgressHUD.dismiss()
                OAuth2TokenStorage.token = authToken
                DispatchQueue.main.async {
                    self.switchToTabBarController()
                }
                self.fetchProfile(token: authToken)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                // TODO [Sprint 11]
                break
            }
        }
    }
    
}
