//
//  MoviePosterCollectionViewCell.swift
//  Movie Time
//
//  Created by Yury Kruk on 16.01.2022.
//

import UIKit
import SDWebImage

class MoviePosterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static Identifiers
    static let identifier = "MoviePosterCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "MoviePosterCollectionViewCell", bundle: nil)
    }
    
    // MARK: - Properties
    @IBOutlet private var nameLabel: UILabel! {
        didSet {
            nameLabel.textColor = .white
        }
    }
    @IBOutlet private var ratingLabel: UILabel! {
        didSet {
            ratingLabel.textColor = .white
        }
    }
    @IBOutlet private var posterImage: UIImageView!
    
    // MARK: Model
    var model: Media?
    
    // MARK: - Configure Cell
    public func configure(model: Media) {
        self.model = model
        self.nameLabel.text = model.title
        self.ratingLabel.text = "★ \(model.rating)"
        
        let imageURL = URL(string: Constants.baseImageURL + model.posterPath)
        self.posterImage.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: Constants.imagePlaceholder), completed: nil)
        
        posterImage.layer.cornerRadius = 20
    }
    
    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayerGradient()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.ratingLabel.text = nil
        self.posterImage.image = nil
    }
    
    // MARK: - Cell Layer Setup
    /// Insert  gradient sublayer for posterImage
    private func setupLayerGradient() {
        let layerGradient = CAGradientLayer()
        layerGradient.colors = [CGColor(gray: 0, alpha: 0), CGColor(gray: 0, alpha: 0.7), CGColor(gray: 0, alpha: 0.8)]
        layerGradient.startPoint = CGPoint(x: 0, y: 0.9)
        layerGradient.endPoint = CGPoint(x: 0, y: 0)
        layerGradient.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: posterImage.frame.height / 3)
        posterImage.layer.insertSublayer(layerGradient, at: 0)
    }
}
