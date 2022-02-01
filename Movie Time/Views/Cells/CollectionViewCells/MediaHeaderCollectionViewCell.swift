//
//  MediaHeaderCollectionViewCell.swift
//  Movie Time
//
//  Created by Yury Kruk on 01.02.2022.
//

import UIKit

class MediaHeaderCollectionViewCell: UICollectionViewCell {

    // MARK: - Identifier & nib()
    static let identifier = "MediaHeaderCollectionViewCell"
    static func nib() -> UINib { return UINib(nibName: "MediaHeaderCollectionViewCell", bundle: nil) }
    
    // MARK: - IBOutlets
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var releaseDateLabel: UILabel!
    
    // MARK: - Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addShadow(offset: CGSize(width: 0, height: 3), color: .black, radius: 10, opacity: 0.3)
        
        titleLabel.text = nil
        releaseDateLabel.text = nil
    }
    
    // MARK: - Configure
    func configure(title: String, releaseDate: String) {
        titleLabel.text = title
        releaseDateLabel.text = releaseDate

    }

}
