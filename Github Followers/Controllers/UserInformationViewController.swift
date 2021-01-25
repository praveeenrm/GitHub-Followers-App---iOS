//
//  UserInformationViewController.swift
//  Github Followers
//
//  Created by PRAVEEN on 23/01/21.
//  Copyright © 2021 Praveen. All rights reserved.
//

import UIKit

class UserInformationViewController: UIViewController {
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isUserInteractionEnabled = true
        
        scroll.delaysContentTouches = false
        scroll.canCancelContentTouches = false
        
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var username: String?
    var userInfo: User?
    var githubUrl: String?
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .label
        spinner.style = .large
        return spinner
    }()
    
    
    // MARK: - Header View
    let headerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textColor = .secondaryLabel
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let locationImage: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "mappin.and.ellipse")
        icon.tintColor = .systemGray
        return icon
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .systemGray
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    
    // MARK: - BioView
    let bioView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 5
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let twitterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    // MARK: - RepoView
    let repoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        return view
    }()
    
    let githubButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Github Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.clipsToBounds = true
        return button
    }()
    
    let publicRepoFolderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        let config = UIImage.SymbolConfiguration(scale: .large)
        imageView.image = UIImage(systemName: "folder", withConfiguration: config)
        return imageView
    }()
    
    let publicRepoLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        label.sizeToFit()
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        label.text = "Public Repos"
        return label
    }()
    
    let repoNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let publicGistImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        let config = UIImage.SymbolConfiguration(scale: .large)
        imageView.image = UIImage(systemName: "text.alignleft", withConfiguration: config)
        return imageView
    }()
    
    let publicGistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        label.sizeToFit()
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        label.text = "Public Gists"
        return label
    }()
    
    let gistNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    
    // MARK: - Follower View
    let getFollowersButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Followers", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.clipsToBounds = true
        return button
    }()
    
    let followerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        return view
    }()
    
    let followerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        let config = UIImage.SymbolConfiguration(scale: .large)
        imageView.image = UIImage(systemName: "suit.heart", withConfiguration: config)
        return imageView
    }()
    
    let followerLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        label.sizeToFit()
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        label.text = "Followers"
        return label
    }()
    
    let followerNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let followingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        let config = UIImage.SymbolConfiguration(scale: .large)
        imageView.image = UIImage(systemName: "person.2", withConfiguration: config)
        return imageView
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        label.sizeToFit()
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        label.text = "Following"
        return label
    }()
    
    let followingNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let footerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissVC))
        
        self.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
    
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        view.addSubview(spinner)

        // bio view
        bioView.addSubview(bioLabel)
        
        // header view
        headerView.addSubview(imageView)
        headerView.addSubview(loginLabel)
        headerView.addSubview(nameLabel)
        headerView.addSubview(locationImage)
        headerView.addSubview(countryLabel)
        
        // repo view
        repoView.addSubview(githubButton)
        repoView.addSubview(publicRepoFolderImage)
        repoView.addSubview(publicRepoLable)
        repoView.addSubview(repoNumber)
        repoView.addSubview(publicGistLabel)
        repoView.addSubview(publicGistImage)
        repoView.addSubview(gistNumber)
        
        // follower view
        followerView.addSubview(getFollowersButton)
        followerView.addSubview(followerImage)
        followerView.addSubview(followerLable)
        followerView.addSubview(followerNumber)
        followerView.addSubview(followingImage)
        followerView.addSubview(followingLabel)
        followerView.addSubview(followingNumber)
        
        contentView.addSubview(headerView)
        contentView.addSubview(bioView)
        contentView.addSubview(repoView)
        contentView.addSubview(followerView)
        contentView.addSubview(footerLabel)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(goToGithubPage))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        githubButton.addGestureRecognizer(gesture)
        
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 700)
        
        getUserInfo(with: username!)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureHeaderView()
        configureBioView()
        configureRepoView()
        configureFollowerView()
        configureFooterLabel()
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureHeaderView() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.90),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            headerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 95),
            imageView.heightAnchor.constraint(equalToConstant: 95),
            
            loginLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            loginLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            locationImage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            locationImage.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            locationImage.widthAnchor.constraint(equalToConstant: 20),
            locationImage.heightAnchor.constraint(equalToConstant: 20),
            
            countryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            countryLabel.leadingAnchor.constraint(equalTo: locationImage.trailingAnchor, constant: 10),
            countryLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
        ])
    }
    
    func configureBioView() {
        NSLayoutConstraint.activate([
            bioView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            bioView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.90),
            bioView.heightAnchor.constraint(equalToConstant: 70),
            bioView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            bioLabel.leadingAnchor.constraint(equalTo: bioView.leadingAnchor, constant: 10),
            bioLabel.topAnchor.constraint(equalTo: bioView.topAnchor, constant: 5),
            bioLabel.widthAnchor.constraint(equalTo: bioView.widthAnchor),
            
        ])
    }
    
    func configureRepoView() {
        
        githubButton.addTarget(self, action: #selector(goToGithubPage), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            repoView.topAnchor.constraint(equalTo: bioView.bottomAnchor, constant: 15),
            repoView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.90),
            repoView.heightAnchor.constraint(equalToConstant: 180),
            repoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            githubButton.bottomAnchor.constraint(equalTo: repoView.bottomAnchor, constant: -30),
            githubButton.leadingAnchor.constraint(equalTo: repoView.leadingAnchor, constant: 20),
            githubButton.trailingAnchor.constraint(equalTo: repoView.trailingAnchor, constant: -20),
            githubButton.heightAnchor.constraint(equalToConstant: 52),
            
            publicRepoFolderImage.leadingAnchor.constraint(equalTo: repoView.leadingAnchor, constant: 20),
            publicRepoFolderImage.topAnchor.constraint(equalTo: repoView.topAnchor, constant: 20),
            
            publicRepoLable.leadingAnchor.constraint(equalTo: publicRepoFolderImage.trailingAnchor, constant: 10),
            publicRepoLable.topAnchor.constraint(equalTo: repoView.topAnchor, constant: 20),
            publicRepoLable.widthAnchor.constraint(equalToConstant: 130),
            
            repoNumber.topAnchor.constraint(equalTo: publicRepoLable.bottomAnchor, constant: 10),
            repoNumber.leadingAnchor.constraint(equalTo: publicRepoLable.leadingAnchor),
            
            publicGistLabel.trailingAnchor.constraint(equalTo: repoView.trailingAnchor, constant: -25),
            publicGistLabel.topAnchor.constraint(equalTo: repoView.topAnchor, constant: 20),
            publicGistLabel.widthAnchor.constraint(equalToConstant: 100),
            
            publicGistImage.trailingAnchor.constraint(equalTo: publicGistLabel.leadingAnchor, constant: -10),
            publicGistImage.topAnchor.constraint(equalTo: repoView.topAnchor, constant: 20),
            
            gistNumber.topAnchor.constraint(equalTo: publicGistLabel.bottomAnchor, constant: 10),
            gistNumber.leadingAnchor.constraint(equalTo: publicGistLabel.leadingAnchor)
        ])
    }
    
    func configureFollowerView() {
        
        getFollowersButton.addTarget(self, action: #selector(didTapGetFollowers), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            followerView.topAnchor.constraint(equalTo: repoView.bottomAnchor, constant: 15),
            followerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.90),
            followerView.heightAnchor.constraint(equalToConstant: 180),
            followerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            getFollowersButton.bottomAnchor.constraint(equalTo: followerView.bottomAnchor, constant: -30),
            getFollowersButton.leadingAnchor.constraint(equalTo: followerView.leadingAnchor, constant: 20),
            getFollowersButton.trailingAnchor.constraint(equalTo: followerView.trailingAnchor, constant: -20),
            getFollowersButton.heightAnchor.constraint(equalToConstant: 52),
            
            followerImage.leadingAnchor.constraint(equalTo: followerView.leadingAnchor, constant: 20),
            followerImage.topAnchor.constraint(equalTo: followerView.topAnchor, constant: 20),
            
            followerLable.leadingAnchor.constraint(equalTo: followerImage.trailingAnchor, constant: 10),
            followerLable.topAnchor.constraint(equalTo: followerView.topAnchor, constant: 20),
            followerLable.widthAnchor.constraint(equalToConstant: 100),
            
            followerNumber.topAnchor.constraint(equalTo: followerLable.bottomAnchor, constant: 10),
            followerNumber.leadingAnchor.constraint(equalTo: followerLable.leadingAnchor),
            
            followingLabel.trailingAnchor.constraint(equalTo: followerView.trailingAnchor, constant: -25),
            followingLabel.topAnchor.constraint(equalTo: followerView.topAnchor, constant: 20),
            followingLabel.widthAnchor.constraint(equalToConstant: 100),
            
            followingImage.trailingAnchor.constraint(equalTo: followingLabel.leadingAnchor, constant: -10),
            followingImage.topAnchor.constraint(equalTo: followerView.topAnchor, constant: 20),
            
            followingNumber.topAnchor.constraint(equalTo: followingLabel.bottomAnchor, constant: 10),
            followingNumber.leadingAnchor.constraint(equalTo: followingLabel.leadingAnchor)
            
        ])
    }
    
    func configureFooterLabel() {
        NSLayoutConstraint.activate([
            footerLabel.topAnchor.constraint(equalTo: followerView.bottomAnchor, constant: 20),
            footerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            footerLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
        ])
    }
}

extension UserInformationViewController {
    
    func getUserInfo(with user: String) {
        
        NetworkManager.shared.getUserInfo(for: user, completion: { [weak self] result in
            guard self != nil else { return }
            
            switch result {
                
            case .success(let user):
                self?.updateUI(with: user)
            case .failure(let error):
                self?.presentAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Okay")
            }
        })
    }
    
    func updateUI(with user: User) {
        DispatchQueue.main.async {
            self.loginLabel.text = user.login
            self.nameLabel.text = user.name
            self.countryLabel.text = user.location
            self.repoNumber.text = "\(user.publicRepos)"
            self.gistNumber.text = "\(user.publicGists)"
            self.followerNumber.text = "\(user.followers)"
            self.followingNumber.text = "\(user.following)"
            self.footerLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
            
            if let bio = user.bio {
                self.bioLabel.text = "\(bio)"
            } else {
                self.bioLabel.text = "\(user.login) has no bio."
            }
            
            self.githubUrl = "\(user.htmlUrl)"
        }
    }
    
    @objc func goToGithubPage() {
//        guard let url = githubUrl, let finalUrl = URL(string: url) else {
//            return
//        }
//        presentSafariVC(with: finalUrl)
        print("safari")
    }
    
    @objc func didTapGetFollowers() {
        let name = self.loginLabel.text
        let vc = self.navigationController?.viewControllers[1] as! FollowersViewController
        vc.username = name
        vc.title = name
        vc.getFollowers()
        self.navigationController?.popToViewController(vc, animated: true)
    }
}
