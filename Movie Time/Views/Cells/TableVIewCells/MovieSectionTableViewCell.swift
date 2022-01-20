//
//  MovieSectionTableViewCell.swift
//  Movie Time
//
//  Created by Yury Kruk on 20.01.2022.
//

import UIKit

class MovieSectionTableViewCell: UITableViewCell {
    
    // MARK: - Static identifier & nib init
    static let identifier = "MovieSectionTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "MovieSectionTableViewCell", bundle: nil)
    }
    
    // MARK: - Objects
    @IBOutlet var backCgroundView: UIView!
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    /// Changes the tint color depending on the adult value
    @IBOutlet var isAdultImage: UIImageView!
    @IBOutlet var releaseDateLabel: UILabel!
    
    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        
        titleLabel.text = nil
        overviewLabel.text = nil
        releaseDateLabel.text = nil
        
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImage.image = nil
        titleLabel.text = nil
        overviewLabel.text = nil
        isAdultImage.tintColor = nil
        releaseDateLabel.text = nil
    }
    
    // MARK: - Configurate
    func configurate(model: Media) {
        if let posterPath = model.posterPath {
            let imageURL = URL(string: Constants.baseImageURL + posterPath)
            posterImage.sd_setImage(with: imageURL, completed: nil)
        } else {
            posterImage.image = UIImage(systemName: Constants.imagePlaceholder)
        }
        
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        let tintColor: UIColor = model.adult ? .systemRed : .placeholderText
        isAdultImage.tintColor = tintColor
        let releaseYear = model.releaseDate.components(separatedBy: "-").first
        releaseDateLabel.text = releaseYear
    }
    
    // MARK: - Cell Layout
    private func setupLayout() {
        backCgroundView.layer.cornerRadius = 20
        backCgroundView.layer.masksToBounds = true
        
        posterImage.layer.cornerRadius = 10
        posterImage.layer.masksToBounds = true
    }
    
}
