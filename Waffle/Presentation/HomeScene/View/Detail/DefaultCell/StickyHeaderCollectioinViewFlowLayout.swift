//
//  StickyHeaderCollectioinViewFlowLayout.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/06.
//

import UIKit

final class StickyHeaderCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var stickyIndexPath: IndexPath? {
        didSet {
            invalidateLayout()
        }
    }
    
    init(stickyIndexPath: IndexPath?) {
        super.init()
        self.stickyIndexPath = stickyIndexPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        if let stickyAttributes = getStickyAttributes(at: stickyIndexPath) {
            layoutAttributes?.append(stickyAttributes)
        }
        
        return layoutAttributes
    }
    
    private func getStickyAttributes(at indexPath: IndexPath?) -> UICollectionViewLayoutAttributes? {
        
        guard let collectionView = collectionView,
              let stickyIndexPath = indexPath,
              let stickyAttributes = layoutAttributesForItem(at: stickyIndexPath)?.copy() as? UICollectionViewLayoutAttributes
        else {
            return nil
        }
        
        if collectionView.contentOffset.y > stickyAttributes.frame.minY {
            var frame = stickyAttributes.frame
            frame.origin.y = collectionView.contentOffset.y
            stickyAttributes.frame = frame
            stickyAttributes.zIndex = 1
            return stickyAttributes
        }
        return nil
    }
    
}
