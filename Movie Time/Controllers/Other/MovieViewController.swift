//
//  MediaViewController.swift
//  Movie Time
//
//  Created by Yury Kruk on 20.01.2022.
//

import UIKit

class MovieViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private var collectionView: UICollectionView!
    
    private let itemInsets = UIEdgeInsets(top: Theme.padding, left: Theme.padding, bottom: Theme.padding, right: Theme.padding)
    
    // MARK: - Model
    private let media: Movie?
    private let model = [MovieViewModel]()
    
    // MARK: - Initializer
    init(media: Movie) {
        self.media = media
        super.init(nibName: "MovieViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetPresentationController?.prefersGrabberVisible = true
        navigationController?.isNavigationBarHidden = true
        
        setupCollectionView()
    }
    
    // MARK: - Setup CollectionView
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        
        // MARK: Register cell
        collectionView.register(MediaPosterCollectionReusableView.nib(),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MediaPosterCollectionReusableView.identifier)
        collectionView.register(MediaHeaderCollectionViewCell.nib(), forCellWithReuseIdentifier: MediaHeaderCollectionViewCell.identifier)
        
        // MARK: Layout CollectionView
        let layout = StretchyHeaderLayout()
        layout.sectionInset = itemInsets
        collectionView.collectionViewLayout = layout
        collectionView.contentInsetAdjustmentBehavior = .automatic
    }
}

// MARK: - ColelctionView DataSource & Delegate
extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let media = media else { return UICollectionViewCell() }
        switch indexPath.row {
        case 0:
            // Header cell (title & release date)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaHeaderCollectionViewCell.identifier, for: indexPath) as! MediaHeaderCollectionViewCell
            cell.configure(title: media.title, releaseDate: media.releaseDate ?? "")
            return cell
            
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            // Footer
            return UICollectionReusableView()
        }
        let posterHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MediaPosterCollectionReusableView.identifier, for: indexPath) as! MediaPosterCollectionReusableView
        posterHeader.configure(imageURL: media?.posterPath)
        
        return posterHeader
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension MovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            // Header cell (title & release date)
            let width = collectionView.frame.width - (itemInsets.left + itemInsets.right)
            return CGSize(width: width, height: 100)
        default:
            return .zero
        }
    }
}
