//
//  FavoritesViewController.swift
//  rick-morty-ios-promass
//
//  Created by seb's on 5/6/26.
//

import UIKit
import SwiftUI

class FavoritesViewController: UIViewController {

    // MARK: - UI
    
    private let tableView = UITableView()
    
    // MARK: - Properties
    
    // Local Core Data favorites.
    private var favorites: [FavoriteCharacterEntity] = []

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        fetchFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Refresh favorites every time the tab appears.
        fetchFavorites()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Data
    
    private func fetchFavorites() {
        favorites = FavoritesManager.shared.fetchFavorites()
        tableView.reloadData()
    }
    
    private func makeCharacter(from favorite: FavoriteCharacterEntity) -> Character {
        let originName = favorite.origin?.isEmpty == false ? favorite.origin! : "Unknown"
        let locationName = favorite.location?.isEmpty == false ? favorite.location! : "Unknown"
        
        return Character(
            id: Int(favorite.id),
            name: favorite.name ?? "",
            status: favorite.status ?? "",
            species: favorite.species ?? "",
            image: favorite.image ?? "",
            type: favorite.type?.isEmpty == false ? favorite.type : nil,
            gender: favorite.gender?.isEmpty == false ? favorite.gender : nil,
            origin: CharacterLocation(name: originName),
            location: CharacterLocation(name: locationName),
            episode: Array(repeating: "", count: Int(favorite.episodeCount))
        )
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "FavoriteBasicCell")
        let favorite = favorites[indexPath.row]
        
        cell.textLabel?.text = favorite.name
        cell.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        cell.textLabel?.textColor = .label
        
        cell.detailTextLabel?.text = "\(favorite.status ?? "") • \(favorite.species ?? "")"
        cell.detailTextLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        cell.detailTextLabel?.textColor = .secondaryLabel
        
        cell.backgroundColor = .systemBackground
        cell.accessoryType = .disclosureIndicator
        
        cell.imageView?.image = UIImage(systemName: "person.crop.square")
        cell.imageView?.tintColor = .secondaryLabel
        cell.imageView?.contentMode = .scaleAspectFill
        
        if let imageString = favorite.image,
           let imageURL = URL(string: imageString) {
            
            URLSession.shared.dataTask(with: imageURL) { data, _, error in
                guard let data = data,
                      error == nil,
                      let image = UIImage(data: data) else {
                    return
                }
                
                DispatchQueue.main.async {
                    if let visibleCell = tableView.cellForRow(at: indexPath) {
                        visibleCell.imageView?.image = image
                        visibleCell.imageView?.layer.cornerRadius = 10
                        visibleCell.imageView?.clipsToBounds = true
                        visibleCell.setNeedsLayout()
                    }
                }
            }.resume()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let favorite = favorites[indexPath.row]
        let character = makeCharacter(from: favorite)
        
        let detailView = CharacterDetailView(character: character)
        let hostingController = UIHostingController(rootView: detailView)
        
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let favorite = favorites[indexPath.row]
            
            FavoritesManager.shared.removeFavorite(characterID: Int(favorite.id))
            
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
