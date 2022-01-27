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
    
    // MARK: - IBOutlets
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var ratingButton: UIButton!
    @IBOutlet private var posterImage: UIImageView!
    
    // MARK: Model
    var model: Movie?
    
    // MARK: - Configure Cell
    public func configure(model: Movie) {
        self.model = model
        
        // Seting poster image
        if let posterPath = model.posterPath {
            let imageURLPath =  Constants.baseImageURL + posterPath
            posterImage.sd_setImage(with: URL(string: imageURLPath), placeholderImage: Theme.imagePlaceholder, completed: nil)
        } else {
            posterImage.image = Theme.imagePlaceholder
        }
        
        // Seting title label
        titleLabel.text = model.title
        
        // Seting a rating button title
        var ratingString = String(model.rating).replacingOccurrences(of: ".", with: "")
        switch model.rating {
        case 0.0:
            ratingButton.setTitle("☆", for: .normal)
        case 0.1...0.9:
            ratingString.removeFirst()
            ratingButton.setTitle("★ \(ratingString)", for: .normal)
        default:
            ratingButton.setTitle("★ \(ratingString)", for: .normal)
        }
    }
    
    // MARK: - Cell LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayerGradient()
        setupIBOutlets()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.ratingButton.setTitle("", for: .normal)
        self.posterImage.image = nil
    }
    
    // MARK: - Cell Layer Setup
    /// Insert  gradient sublayer for posterImage
    private func setupLayerGradient() {
        let layerGradient = CAGradientLayer()
        layerGradient.colors = [CGColor(gray: 0, alpha: 0), CGColor(gray: 0, alpha: 0.5), CGColor(gray: 0, alpha: 0.8)]
        layerGradient.startPoint = CGPoint(x: 0, y: 0.9)
        layerGradient.endPoint = CGPoint(x: 0, y: 0.1)
        layerGradient.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height / 4)
        posterImage.layer.insertSublayer(layerGradient, at: 0)
    }
    
    private func setupIBOutlets() {
        // The Title Label
        titleLabel.textColor = Theme.whitePrimaryColor
        
        // The Poster Image
        posterImage.layer.cornerRadius = 20
        posterImage.layer.masksToBounds = true
        
        // The Rating Button
        ratingButton.titleLabel?.textColor = Theme.whitePrimaryColor
        ratingButton.backgroundColor = .black.withAlphaComponent(0.5)
        ratingButton.layer.cornerRadius = 6
    }
}
