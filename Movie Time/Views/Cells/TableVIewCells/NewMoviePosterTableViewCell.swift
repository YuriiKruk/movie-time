//
//  NewMoviePosterTableViewCell.swift
//  Movie Time
//
//  Created by Yury Kruk on 16.01.2022.
//

import UIKit

// MARK: - NewMoviePosterTableViewCellDelegate
protocol NewMoviePosterTableViewCellDelegate: AnyObject {
    func didTapPoster(cellView: NewMoviePosterTableViewCell, model: Movie)
}

class NewMoviePosterTableViewCell: UITableViewCell, NibSetapable {
    
    // MARK: Delegate
    weak var delegate: NewMoviePosterTableViewCellDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet private var collectionView: UICollectionView!
    
    private let sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: Theme.padding, bottom: 0, right: Theme.padding)
    /// Size for  collection view cell
    /// - The item height must be less than the height of the UICollectionView minus the section insets top and bottom values, minus the content insets top and bottom values
    lazy private var cellSize = CGSize(width: contentView.frame.height * 0.6, height: contentView.frame.height - 1)
    
    // MARK: Model
    private var model = [Movie]()
    
    // MARK: - Configure Cell
    public func configure(model: [Movie]) {
        self.model = model
    }
    
    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MoviePosterCollectionViewCell.nib(), forCellWithReuseIdentifier: MoviePosterCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        
        setupCollectionLayout()
    }
    
    // MARK: Collection View Layout
    private func setupCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.collectionView?.isPagingEnabled = true
        layout.sectionInset = sectionInset
        collectionView.collectionViewLayout = layout
    }
}

// MARK: - Setup Collection View Delegate & Data Sourse Delegate
extension NewMoviePosterTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCollectionViewCell.identifier, for: indexPath) as! MoviePosterCollectionViewCell
        cell.configure(model: model[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MoviePosterCollectionViewCell else {
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 2,
                options: .curveEaseOut
            ) {
                cell.transform = .identity
            }
        completion: { _ in }
        }
        
        delegate?.didTapPoster(cellView: self, model: cell.model!)
    }
}

// MARK: - Setup Collection View Flow Layout Delegate
extension NewMoviePosterTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellSize
    }
}


