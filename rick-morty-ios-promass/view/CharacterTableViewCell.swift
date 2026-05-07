//
//  CharacterTableViewCell.swift
//  rick-morty-ios-promass
//
//  Created by seb's on 5/6/26.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var onFavoriteTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        characterImageView.layer.cornerRadius = 12
        characterImageView.clipsToBounds = true
        characterImageView.contentMode = .scaleAspectFill
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        characterImageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
        speciesLabel.text = nil
        favoriteButton.setTitle("☆", for: .normal)
        onFavoriteTapped = nil
    }
    
    func configure(with character: Character, isFavorite: Bool = false) {
        nameLabel.text = character.name
        statusLabel.text = "Status: \(character.status)"
        speciesLabel.text = "Species: \(character.species)"
        
        favoriteButton.setTitle(isFavorite ? "★" : "☆", for: .normal)
        
        guard let imageURL = URL(string: character.image) else {
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
            
            guard let data = data,
                  error == nil,
                  let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.characterImageView.image = image
            }
            
        }.resume()
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        onFavoriteTapped?()
    }
}
