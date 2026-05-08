//
//  CharacterTableViewCell.swift
//  rick-morty-ios-promass
//
//  Created by seb's on 5/6/26.
//
import UIKit

class CharacterTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Actions
    
    var onFavoriteTapped: (() -> Void)?

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupImageView()
        setupLabels()
        setupFavoriteButton()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        characterImageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
        speciesLabel.text = nil
        onFavoriteTapped = nil
        
        setFavoriteButton(isFavorite: false)
    }
    
    // MARK: - Configuration
    
    func configure(with character: Character, isFavorite: Bool = false) {
        nameLabel.text = character.name
        statusLabel.text = "Status: \(character.status)"
        speciesLabel.text = "Species: \(character.species)"
        
        setFavoriteButton(isFavorite: isFavorite)
        loadImage(from: character.image)
    }
    
    // MARK: - Setup
    
    private func setupImageView() {
        characterImageView.layer.cornerRadius = 0
        characterImageView.clipsToBounds = true
        characterImageView.contentMode = .scaleAspectFill
    }
    
    private func setupLabels() {
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        
        statusLabel.numberOfLines = 1
        statusLabel.lineBreakMode = .byTruncatingTail
        
        speciesLabel.numberOfLines = 1
        speciesLabel.lineBreakMode = .byTruncatingTail
    }
    
    private func setupFavoriteButton() {
        favoriteButton.setContentHuggingPriority(.required, for: .horizontal)
        favoriteButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        setFavoriteButton(isFavorite: false)
    }
    
    private func setFavoriteButton(isFavorite: Bool) {
        let star = isFavorite ? "★" : "☆"
        
        let attributedTitle = NSAttributedString(
            string: star,
            attributes: [
                .font: UIFont.systemFont(ofSize: 30, weight: .regular),
                .foregroundColor: UIColor.systemBlue
            ]
        )
        
        favoriteButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    private func loadImage(from imageURLString: String) {
        guard let imageURL = URL(string: imageURLString) else {
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
    
    // MARK: - IBAction
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        onFavoriteTapped?()
    }
}
