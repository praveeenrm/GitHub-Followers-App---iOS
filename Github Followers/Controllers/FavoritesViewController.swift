//
//  FavoritesViewController.swift
//  Github Followers
//
//  Created by PRAVEEN on 22/01/21.
//  Copyright © 2021 Praveen. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var favorites: [Follower] = []

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = false
        imageView.image = UIImage(named: "empty")
        return imageView
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.numberOfLines = 3
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textColor = .secondaryLabel
        label.text = "No Favorites?\nAdd one on the Follower screen."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        view.addSubview(imageView)
        view.addSubview(messageLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureTableView()
        configureEmptyStateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    func configureTableView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
    
    func getFavorites() {
        PersistentManager.retrieveFavorites(completion: { [weak self] result in
            guard self != nil else { return }
            
            switch result {
                
            case .success(let favorites):
                self?.updateUI(with: favorites)
                
            case .failure(let error):
                self?.presentAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Okay")
            }
        })
    }
    
    func updateUI(with favorites: [Follower]) {
        if favorites.isEmpty {
            // show empty state
            tableView.isHidden = true
            messageLabel.isHidden = false
            imageView.isHidden = false
        } else {
            tableView.isHidden = false
            imageView.isHidden = true
            messageLabel.isHidden = true
            DispatchQueue.main.async {
                self.favorites = favorites
                self.tableView.reloadData()
            }
        }
    }
    
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = favorites[indexPath.row].login
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        PersistentManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove, completion: { [weak self] error in
            guard self != nil else { return }
            
            guard let error = error else {
                self?.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            
            self?.presentAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Okay")
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let favorite = favorites[indexPath.row]
        let vc = FollowersViewController()
        vc.username = favorite.login
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

