//
//  CharactersViewController.swift
//  rick-morty-ios-promass
//
//  Created by seb's on 5/6/26.
//

import UIKit

class CharactersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var characters: [Character] = []
    var nextPageURL: String?
    var isLoading = false
    var isSearching = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        
        setupSearchController()

        fetchData()
    }
    
    func setupSearchController() {
        title = "Characters"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        if #available(iOS 16.0, *) {
            navigationItem.preferredSearchBarPlacement = .stacked
        }
        
        
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search characters"
        
        definesPresentationContext = true
    }

    func fetchData() {
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
            }
        }
    }
    
    func loadMoreCharacters() {
        guard !isLoading else { return }
        guard !isSearching else { return }
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
            }
        }
    }
    
    func searchCharacters(with name: String) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            fetchData()
            return
        }
        
        isSearching = true
        
        APIService.shared.searchCharacters(name: name) { [weak self] result in
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
}

extension CharactersViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CharacterCell",
            for: indexPath
        ) as? CharacterTableViewCell else {
            return UITableViewCell()
        }

        let character = characters[indexPath.row]
        cell.configure(with: character)

        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > contentHeight - scrollViewHeight - 100 {
            loadMoreCharacters()
        }
    }
}

extension CharactersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCharacters(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchData()
    }
}
