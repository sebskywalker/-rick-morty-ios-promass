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
    
    override func viewDidLoad() {

            super.viewDidLoad()

            tableView.delegate = self

            tableView.dataSource = self

            fetchData()

        }

        

        func fetchData() {

            APIService.shared.fetchCharacters { [weak self] result in

                switch result {

                case .success(let characters):

                    self?.characters = characters

                    print("Personajes cargados:", characters.count)

                    self?.tableView.reloadData()

                    

                case .failure(let error):

                    print("Error al cargar personajes:", error.localizedDescription)

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
    }
