//
//  PersistentManager.swift
//  Github Followers
//
//  Created by PRAVEEN on 24/01/21.
//  Copyright © 2021 Praveen. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

struct PersistentManager {
    
    static let shared = PersistentManager()
    
    static let defaults = UserDefaults.standard
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping (CustomError?) -> Void) {
        
        retrieveFavorites(completion: { result in
            switch result {
                
            case .success(var favorites):
                
                switch actionType {
                
                case .add:
                    guard !favorites.contains(favorite) else {
                        completion(.alreadyInFavorites)
                        return
                    }
                    
                    favorites.append(favorite)
                
                case .remove:
                    favorites.removeAll(where: {
                        $0.login == favorite.login
                    })
                }
                
                completion(save(favorites: favorites))
                
            case .failure(let error):
                completion(error)
            }
        })
        
        
    }
    
    static func retrieveFavorites(completion: @escaping (Result<[Follower], CustomError>) -> Void ) {
        guard let favoritesData = defaults.object(forKey: "favorites") as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
        
    }
    
    static func save(favorites: [Follower]) -> CustomError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: "favorites")
            return nil
        } catch {
            return .unableToFavorite
        }
    }
    
}
