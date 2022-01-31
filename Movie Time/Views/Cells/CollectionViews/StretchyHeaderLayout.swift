//
//  StretchyHeaderLayout.swift
//  Movie Time
//
//  Created by Yury Kruk on 28.01.2022.
//

import UIKit

class StretchyHeaderLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layout = super.layoutAttributesForElements(in: rect)
        
        layout?.forEach({ attributes in
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader && attributes.indexPath.section == 0 {
                
                guard let collectionView = collectionView else { return }
                let width = collectionView.frame.width
                let contentOffsetY = collectionView.contentOffset.y
                
                // Header
                let height = attributes.frame.height - contentOffsetY
                
                if contentOffsetY > 0 {
                    return
                }
                
                attributes.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
            }
        })
        
        return layout
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
