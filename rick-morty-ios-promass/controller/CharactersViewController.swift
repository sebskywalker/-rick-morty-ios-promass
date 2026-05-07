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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120

        fetchData()
    }

    func fetchData() {
        guard !isLoading else { return }
        
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
