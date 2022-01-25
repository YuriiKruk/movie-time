//
//  MediaViewController.swift
//  Movie Time
//
//  Created by Yury Kruk on 20.01.2022.
//

import UIKit

class MediaViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: - Model
    private let media: Movie?
    private let model = [MediaViewModel]()
    
    // MARK: - Initializer
    init(media: Movie) {
        self.media = media
        super.init(nibName: "MediaViewController", bundle: nil)
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
        
        // MARK: Register cell
        collectionView.register(MoviePosterCollectionViewCell.nib(), forCellWithReuseIdentifier: MoviePosterCollectionViewCell.identifier)
    }

}

extension MediaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
