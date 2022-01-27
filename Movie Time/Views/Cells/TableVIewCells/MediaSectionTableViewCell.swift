//
//  MediaSectionTableViewCell.swift
//  Movie Time
//
//  Created by Yury Kruk on 20.01.2022.
//

import UIKit

protocol MediaSectionTableViewCellDelegate: AnyObject {
    func didTapSectionCell(cellView: MediaSectionTableViewCell, mediaType: MediaType, model: Any)
}

class MediaSectionTableViewCell: UITableViewCell, NibSetapable {
    
    weak var delegate: MediaSectionTableViewCellDelegate?
    
    // MARK: - Model
    private var media: Any?
    private var mediaType: MediaType?
    
    // MARK: - IBOutlets
    @IBOutlet private var generalView: UIView!
    @IBOutlet private var backgroundImage: UIImageView!
    @IBOutlet private var posterImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var overviewLabel: UILabel!
    /// Changes the tint color depending on the adult value
    @IBOutlet private var isAdultImage: UIImageView!
    @IBOutlet private var releaseDateLabel: UILabel!
    @IBOutlet private var topGestureView: UIView!
    
    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        
        setupIBOutlets()
        setupBackgroundBlurEffect()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        topGestureView.addGestureRecognizer(tapGesture)
        topGestureView.isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImage.image = nil
        backgroundImage.image = nil
        titleLabel.text = nil
        overviewLabel.text = nil
        isAdultImage.tintColor = nil
        releaseDateLabel.text = nil
    }
    
    // MARK: - Create Did Tap Cell
    @objc private func didTapCell() {
        guard let media = media, let mediaType = mediaType else {
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn) { [weak self] in
            self?.generalView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { [weak self] _ in
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 2,
                options: .curveEaseOut
            ) {
                self?.generalView.transform = .identity
            }
        completion: { _ in }
        }
        delegate?.didTapSectionCell(cellView: self, mediaType: mediaType, model: media)
    }
    
    // MARK: - Setup IBOutlets
    private func setupIBOutlets() {
        titleLabel.text = nil
        titleLabel.textColor = Theme.primaryLabelColor
        
        overviewLabel.text = nil
        overviewLabel.textColor = Theme.secondaryLabelColor
        
        releaseDateLabel.text = nil
        releaseDateLabel.textColor = Theme.secondaryLabelColor
        
        generalView.backgroundColor = .clear
        generalView.layer.cornerRadius = 20
        generalView.layer.masksToBounds = true
                
        posterImage.layer.cornerRadius = 10
        posterImage.layer.masksToBounds = true
    }
    
    // MARK: Setup blur background image
    private func setupBackgroundBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImage.bounds
        backgroundImage.addSubview(blurEffectView)
    }
    
    // MARK: - Configurate
    func configurate(model: Any) {
        if let model = model as? Movie {
            // MARK: Seting Movie Model
            self.media = model
            self.mediaType = .movie
            
            // Setting poster image
            if let posterPath = model.posterPath {
                let imageURL = URL(string: Constants.baseImageURL + posterPath)
                posterImage.sd_setImage(with: imageURL, completed: nil)
            } else {
                posterImage.image = Theme.imagePlaceholder
            }
            
            // Seting movie title label
            titleLabel.text = model.title
            
            // Seting movie overview label
            overviewLabel.text = model.overview
            
            // Seting movie adult image
            if let isAdult = model.adult {
                let tintColor: UIColor = isAdult ? .systemRed : .placeholderText
                isAdultImage.tintColor = tintColor
            } else {
                isAdultImage.isHidden = true
            }
            
            // Seting movie release label
            let releaseYear = model.releaseDate?.components(separatedBy: "-").first
            releaseDateLabel.text = releaseYear
            
            // Seting cell background image
            if let posterPath = model.posterPath {
                let imageURL = URL(string: Constants.baseImageURL + posterPath)
                backgroundImage.sd_setImage(with: imageURL, completed: nil)
                //backgroundImage.applyBlurEffect()
            } else {
                backgroundImage.image = Theme.imagePlaceholder
            }

        } else if let model = model as? TVShow {
            // MARK: Seting TV Model
            self.media = model
            self.mediaType = .tv
            
            // Setting tv poster image
            if let posterPath = model.posterPath {
                let imageURL = URL(string: Constants.baseImageURL + posterPath)
                posterImage.sd_setImage(with: imageURL, completed: nil)
            } else {
                posterImage.image = Theme.imagePlaceholder
            }
            
            // Seting tv title label
            titleLabel.text = model.name
            
            // Seting tv overview label
            overviewLabel.text = model.overview
            
            // Seting movie release label
            let releaseYear = model.releaseDate.components(separatedBy: "-").first
            releaseDateLabel.text = releaseYear
        }
    }
}
