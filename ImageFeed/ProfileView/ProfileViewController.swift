import UIKit

class ProfileViewController: UIViewController {
    
    private var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureProfileImageView()
        configureUserNameLabel()
        configureNickNameLabel()
        configureDescriptionLabel()
        configureExitButton()
    }
    
    private func configureProfileImageView() {
        let profileImage = UIImage(named: "Photo")
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = .ypGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func configureUserNameLabel() {
        let labelUserName = UILabel()
        labelUserName.text = "Екатерина Новикова"
        labelUserName.textColor = .ypWhite
        labelUserName.font = UIFont(name: "HelveticaNeue-Medium", size: 23)
        labelUserName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelUserName)
        labelUserName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        labelUserName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120).isActive = true
        self.label = labelUserName
    }
    
    private func configureNickNameLabel() {
        let labelnickName = UILabel()
        labelnickName.text = "@ekaterina_nov"
        labelnickName.textColor = .ypGray
        labelnickName.font = UIFont(name: "HelveticaNeue", size: 13)
        labelnickName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelnickName)
        labelnickName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        labelnickName.topAnchor.constraint(equalTo: label?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.label = labelnickName
    }
    
    private func configureDescriptionLabel() {
        let labelDescription = UILabel()
        labelDescription.text = "Hello, World"
        labelDescription.textColor = .ypWhite
        labelDescription.font = UIFont(name: "HelveticaNeue", size: 13)
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelDescription)
        labelDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        labelDescription.topAnchor.constraint(equalTo: label?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.label = labelDescription
    }
    
    private func configureExitButton() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Exit"), for: .normal)
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
}
