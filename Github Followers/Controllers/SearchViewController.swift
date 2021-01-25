//
//  SearchViewController.swift
//  Github Followers
//
//  Created by PRAVEEN on 22/01/21.
//  Copyright © 2021 Praveen. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    let searchTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Enter a username"
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor.systemGray4.cgColor
        field.font = .systemFont(ofSize: 24, weight: .regular)
        field.textAlignment = .center
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.textColor = .label
        field.tintColor = .label
        field.returnKeyType = .go
        field.clearButtonMode = .whileEditing
        return field
    }()
    
    let getFollowersButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Followers", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(getFollowersButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(logoImageView)
        view.addSubview(searchTextField)
        view.addSubview(getFollowersButton)
        searchTextField.becomeFirstResponder()
        searchTextField.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLogoImageView()
        configureSearchTextField()
        configureGetFollowersButton()
    }
    
    // Logo
    func configureLogoImageView() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // Text Field
    func configureSearchTextField() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            searchTextField.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    // Get Followers Button
    func configureGetFollowersButton() {
        NSLayoutConstraint.activate([
            getFollowersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            getFollowersButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            getFollowersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            getFollowersButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func getFollowersButtonPressed() {
        guard let username = searchTextField.text, !username.isEmpty else {
            showAlert()
            return
        }
        searchTextField.resignFirstResponder()
        let vc = FollowersViewController()
        vc.username = username
        navigationController?.pushViewController(vc, animated: true)
        searchTextField.text = ""
    }
    
    func showAlert() {
        presentAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 😄.", buttonTitle: "Okay")
    }

}


extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getFollowersButtonPressed()
        return true
    }
    
}
