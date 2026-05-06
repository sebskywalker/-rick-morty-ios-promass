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
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        statusLabel.text = "Status: \(character.status)"
        speciesLabel.text = "Species: \(character.species)"
        favoriteButton.setTitle("☆", for: .normal)
    }
}
