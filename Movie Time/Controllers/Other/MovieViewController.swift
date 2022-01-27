//
//  MediaViewController.swift
//  Movie Time
//
//  Created by Yury Kruk on 20.01.2022.
//

import UIKit

class MovieViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private var collectionView: UICollectionView!
    
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
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Configure TableView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MediaPosterCollectionReusableView.nib(),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MediaPosterCollectionReusableView.identifier)
        
        // MARK: Register cell
        collectionView.register(MoviePosterCollectionViewCell.nib(), forCellWithReuseIdentifier: MoviePosterCollectionViewCell.identifier)
    }

}

extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            // Footer
            return UICollectionReusableView()
        }
        
        switch indexPath.section {
        case 0:
            let posterHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MediaPosterCollectionReusableView.identifier, for: indexPath) as! MediaPosterCollectionReusableView
            posterHeader.configure(imageURL: media?.posterPath)
            return posterHeader
        default:
            return UICollectionReusableView()
        }
    }
}

extension MovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 2)
    }
}
