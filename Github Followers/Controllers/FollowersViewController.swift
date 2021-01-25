//
//  FollowersViewController.swift
//  Github Followers
//
//  Created by PRAVEEN on 23/01/21.
//  Copyright © 2021 Praveen. All rights reserved.
//

import UIKit
import SDWebImage

struct Follower: Codable, Hashable {
    var login: String
    var avatar_url: String
}

struct User: Codable {
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: Date
}

class FollowersViewController: UIViewController {

    var username: String!
    var mainFollowers: [Follower] = []
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 40
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        view.register(FollowerCell.self, forCellWithReuseIdentifier: "cell")
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        imageView.image = UIImage(named: "empty")
        return imageView
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .label
        spinner.style = .large
        return spinner
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.numberOfLines = 3
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textColor = .secondaryLabel
        label.text = "This user has does not have any followers. Go follow them ☺️."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        title = username
        view.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        view.addSubview(spinner)
        view.addSubview(imageView)
        view.addSubview(messageLabel)
        
        getFollowers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureSpinner()
        configureCollectionView()
        configureEmptyStateView()
    }
    
    func configureSpinner() {
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func configureEmptyStateView() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.3),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.3),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 170),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 40),
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func getFollowers() {
    
        spinner.startAnimating()
        NetworkManager.shared.getFollowers(for: username, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
                
            case .success(let followers):
                // update UI
                if followers.isEmpty {
                    DispatchQueue.main.async {
                        strongSelf.collectionView.isHidden = true
                        strongSelf.imageView.isHidden = false
                        strongSelf.messageLabel.isHidden = false
                        strongSelf.spinner.stopAnimating()
                    }
                } else {
                    
                    DispatchQueue.main.async {
                        strongSelf.collectionView.isHidden = false
                        strongSelf.imageView.isHidden = true
                        strongSelf.messageLabel.isHidden = true
                        strongSelf.mainFollowers = followers
                        strongSelf.collectionView.reloadData()
                        strongSelf.spinner.stopAnimating()
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        })
    }
    
    @objc func addButtonTapped() {
        NetworkManager.shared.getUserInfo(for: username, completion: { [weak self] result in
            guard self != nil else {
                return
            }
            switch result {
                
            case .success(let user):
                self?.addToFavorites(user: user)
            case .failure(let error):
                self?.presentAlertOnMainThread(title: "Something went wrok", message: error.rawValue, buttonTitle: "Okay")
            }
        })
    }
    
    func addToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatar_url: user.avatarUrl)
        
        PersistentManager.updateWith(favorite: favorite, actionType: .add, completion: { [weak self] error in
            guard self != nil else {
                return
            }
            
            guard let error = error else {
                self?.presentAlertOnMainThread(title: "Success", message: "User successfully added to favorites 🎉.", buttonTitle: "Hooray")
                return
            }
            
            self?.presentAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Okay")

        })
        
    }
    
}


extension FollowersViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.5, height: collectionView.frame.width/3.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainFollowers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FollowerCell
        let follower = mainFollowers[indexPath.row]
        let url = follower.avatar_url

        cell.nameLabel.text = follower.login
        cell.imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "avatar"), options: .continueInBackground, completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let follower = mainFollowers[indexPath.row]
        let url = follower.avatar_url
        
        let vc = UserInformationViewController()
        vc.username = follower.login
        vc.imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "avatar"), options: .continueInBackground, completed: nil)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
}

class FollowerCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.tintColor = .systemGreen
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            nameLabel.heightAnchor.constraint(equalToConstant: 24)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
