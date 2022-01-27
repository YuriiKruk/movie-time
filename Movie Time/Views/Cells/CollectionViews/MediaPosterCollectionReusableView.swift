//
//  MediaPosterCollectionReusableView.swift
//  Movie Time
//
//  Created by Yury Kruk on 27.01.2022.
//

import UIKit
import SDWebImage

class MediaPosterCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Static identifier & nib reference
    static let identifier = "MediaPosterCollectionReusableView"
    static func nib() -> UINib { UINib(nibName: identifier, bundle: nil) }
    
    // MARK: - IBOutlets
    @IBOutlet private var backGroundImage: UIImageView!
    @IBOutlet private var blurEffectView: UIVisualEffectView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var posterImage: UIImageView!
    
    // MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupIBOutlets()
    }
    
    // MARK: - Configure view
    func configure(imageURL posterPath: String?) {
        if let posterPath = posterPath {
            let url = URL(string: Constants.baseImageURL + posterPath)
            let image = UIImageView()
            image.sd_setImage(with: url) { [weak self] image, error, _, _ in
                guard let image = image, error == nil else {
                    self?.backGroundImage.image = Theme.imagePlaceholder
                    self?.posterImage.image = Theme.imagePlaceholder
                    return
                }
                self?.backGroundImage.image = image
                self?.posterImage.image = image
            }
        }
    }
    
    // MARK: - Setup IBOutlets
    private func setupIBOutlets() {
        backGroundImage.layer.cornerRadius = 10
        backGroundImage.clipsToBounds = true
        
        blurEffectView.effect = UIBlurEffect(style: .systemChromeMaterial)
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.clipsToBounds = true
        
        containerView.addShadow(offset: CGSize(width: 0, height: 5), color: .black, radius: 10, opacity: 0.5)
        
        posterImage.layer.cornerRadius = 10
        posterImage.clipsToBounds = true
    }
    
}
