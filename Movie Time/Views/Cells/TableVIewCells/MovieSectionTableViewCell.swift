//
//  MovieSectionTableViewCell.swift
//  Movie Time
//
//  Created by Yury Kruk on 20.01.2022.
//

import UIKit

protocol MovieSectionTableViewCellDelegate: AnyObject {
    func didTapSectionCell(model: Movie)
}

class MovieSectionTableViewCell: UITableViewCell, NibSetapable {

    weak var delegate: MovieSectionTableViewCellDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet private var backCgroundView: UIView!
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
        
        titleLabel.text = nil
        overviewLabel.text = nil
        releaseDateLabel.text = nil
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        topGestureView.addGestureRecognizer(tapGesture)
        topGestureView.isUserInteractionEnabled = true
        
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
    
    // MARK: - Methods
    @objc private func didTapCell() {
        guard let media = media else {
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn) { [weak self] in
            self?.backCgroundView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { [weak self] _ in
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 2,
                options: .curveEaseOut
            ) {
                self?.backCgroundView.transform = .identity
            }
        completion: { _ in }
        }
        delegate?.didTapSectionCell(model: media)
    }
    
    // MARK: - Model
    private var media: Movie?

    // MARK: - Configurate
    func configurate(model: Any) {
        if let model = model as? Movie {
            media = model
            if let posterPath = model.posterPath {
                let imageURL = URL(string: Constants.baseImageURL + posterPath)
                posterImage.sd_setImage(with: imageURL, completed: nil)
            } else {
                posterImage.image = UIImage(systemName: Constants.imagePlaceholder)
            }
            
            titleLabel.text = model.title
            overviewLabel.text = model.overview
            if let adult = model.adult {
                let tintColor: UIColor = adult ? .systemRed : .placeholderText
                isAdultImage.tintColor = tintColor
            } else {
                isAdultImage.isHidden = true
            }
            let releaseYear = model.releaseDate?.components(separatedBy: "-").first
            releaseDateLabel.text = releaseYear
        } else if let model = model as? TVShow {
            if let posterPath = model.posterPath {
                let imageURL = URL(string: Constants.baseImageURL + posterPath)
                posterImage.sd_setImage(with: imageURL, completed: nil)
            } else {
                posterImage.image = UIImage(systemName: Constants.imagePlaceholder)
            }
            
            titleLabel.text = model.name
            overviewLabel.text = model.overview
            let releaseYear = model.releaseDate.components(separatedBy: "-").first
            releaseDateLabel.text = releaseYear
        } else if let model = model as? Person {
            if let posterPath = model.profilePath {
                let imageURL = URL(string: Constants.baseImageURL + posterPath)
                posterImage.sd_setImage(with: imageURL, completed: nil)
            } else {
                posterImage.image = UIImage(systemName: Constants.imagePlaceholder)
            }
            
            titleLabel.text = model.name
            overviewLabel.text = model.knownForDepartment
            
            if let adult = model.adult {
                let tintColor: UIColor = adult ? .systemRed : .placeholderText
                isAdultImage.tintColor = tintColor
            } else {
                isAdultImage.isHidden = true
            }
            
        }
    }
    
    // MARK: - Cell Layout
    private func setupLayout() {
        backCgroundView.layer.cornerRadius = 20
        backCgroundView.layer.masksToBounds = true
        
        posterImage.layer.cornerRadius = 10
        posterImage.layer.masksToBounds = true
    }
    
}
