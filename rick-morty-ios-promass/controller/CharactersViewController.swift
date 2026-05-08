//
//  CharactersViewController.swift
//  rick-morty-ios-promass
//
//  Created by seb's on 5/6/26.
//
import UIKit
import SwiftUI

class CharactersViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    // Main data source for the UITableView.
    private var characters: [Character] = []
    
    // Stores the next page URL returned by the API for pagination.
    private var nextPageURL: String?
    
    // Prevents duplicated API calls while another request is running.
    private var isLoading = false
    
    // Prevents pagination while the user is searching.
    private var isSearching = false
    
    // Ensures the initial API request is triggered once the view is visible.
    private var hasLoadedInitialData = false
    
    // Native UIKit search controller used to search characters by name.
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Alerts should be presented only after the view is visible.
        // This avoids trying to present an alert too early from viewDidLoad.
        guard !hasLoadedInitialData else { return }
        hasLoadedInitialData = true
        
        fetchData()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.backgroundColor = .systemBackground
    }
    
    private func setupSearchController() {
        title = "Characters"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Keeps the search bar placed at the top on modern iOS versions.
        if #available(iOS 16.0, *) {
            navigationItem.preferredSearchBarPlacement = .stacked
        }
        
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search characters"
        
        definesPresentationContext = true
    }
    
    // MARK: - Networking
    
    private func fetchData() {
        // If there is no connection, show the offline fallback flow.
        guard NetworkMonitor.shared.isConnected else {
            showOfflineAlert()
            return
        }
        
        guard !isLoading else { return }
        
        isSearching = false
        isLoading = true

        APIService.shared.fetchCharacters { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false

            switch result {
            case .success(let response):
                self.characters = response.results
                self.nextPageURL = response.info.next
                
                print("Personajes cargados:", self.characters.count)
                print("Siguiente página:", self.nextPageURL ?? "No hay más")
                
                self.tableView.reloadData()

            case .failure(let error):
                print("Error al cargar personajes:", error.localizedDescription)
                self.showOfflineAlert()
            }
        }
    }
    
    private func loadMoreCharacters() {
        // Avoid pagination if there is no internet connection.
        guard NetworkMonitor.shared.isConnected else {
            showOfflineAlert()
            return
        }
        
        // Avoid duplicate requests.
        guard !isLoading else { return }
        
        // Do not paginate while searching.
        guard !isSearching else { return }
        
        // If there is no next URL, there are no more pages.
        guard let nextPageURL = nextPageURL else { return }
        
        isLoading = true
        
        APIService.shared.fetchCharacters(from: nextPageURL) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let response):
                self.characters.append(contentsOf: response.results)
                self.nextPageURL = response.info.next
                
                print("Total personajes:", self.characters.count)
                print("Siguiente página:", self.nextPageURL ?? "No hay más")
                
                self.tableView.reloadData()
                
            case .failure(let error):
                print("Error al cargar más personajes:", error.localizedDescription)
                self.showOfflineAlert()
            }
        }
    }
    
    private func searchCharacters(with name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // If search is empty, restore the main list.
        guard !trimmedName.isEmpty else {
            fetchData()
            return
        }
        
        guard NetworkMonitor.shared.isConnected else {
            showOfflineAlert()
            return
        }
        
        isSearching = true
        
        APIService.shared.searchCharacters(name: trimmedName) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.characters = response.results
                self.nextPageURL = response.info.next
                self.tableView.reloadData()
                
            case .failure(let error):
                print("Search error:", error.localizedDescription)
                self.characters = []
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Offline Handling
    
    private func showOfflineAlert() {
        // Prevents presenting multiple alerts at the same time.
        guard presentedViewController == nil else { return }
        
        let favorites = FavoritesManager.shared.fetchFavorites()
        
        let alert = UIAlertController(
            title: "No internet connection",
            message: favorites.isEmpty
            ? "You will be able to view characters offline once you add favorites."
            : "You can retry the connection or view your saved favorites.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.fetchData()
        })
        
        if !favorites.isEmpty {
            alert.addAction(UIAlertAction(title: "View Favorites", style: .default) { [weak self] _ in
                self?.tabBarController?.selectedIndex = 1
            })
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension CharactersViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CharacterCell",
            for: indexPath
        ) as? CharacterTableViewCell else {
            return UITableViewCell()
        }

        let character = characters[indexPath.row]
        let isFavorite = FavoritesManager.shared.isFavorite(characterID: character.id)
        
        cell.configure(with: character, isFavorite: isFavorite)
        
        // Closure used by the cell to notify the controller when the favorite button is tapped.
        cell.onFavoriteTapped = { [weak self] in
            guard let self = self else { return }
            
            if FavoritesManager.shared.isFavorite(characterID: character.id) {
                FavoritesManager.shared.removeFavorite(characterID: character.id)
            } else {
                FavoritesManager.shared.saveFavorite(character: character)
            }
            
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCharacter = characters[indexPath.row]
        
        // UIKit → SwiftUI bridge.
        // UIHostingController allows presenting a SwiftUI view inside a UIKit navigation stack.
        let detailView = CharacterDetailView(character: selectedCharacter)
        let hostingController = UIHostingController(rootView: detailView)
        
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        // Triggers pagination when the user is close to the bottom.
        if position > contentHeight - scrollViewHeight - 100 {
            loadMoreCharacters()
        }
    }
}

// MARK: - UISearchBarDelegate

extension CharactersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCharacters(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchData()
    }
}
