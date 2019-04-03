//
//  DaysCollectionFlowLayout.swift
//  Watcher
//
//  Created by Петр Первухин on 22/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class DaysCollectionFlowLayout: UICollectionViewFlowLayout {
   
    // MARK: - Private Properties

    private var isSetup = false
    private let itemSpacing: CGFloat = 12
    private let sectionInsets = UIEdgeInsets(top: 0, 
                                             left: 16, 
                                             bottom: 0, 
                                             right: 16)
    
    
    // MARK: - Prepare

    override func prepare() {
        super.prepare() 
        if isSetup == false {
            setupCollectionView()
            isSetup = true
        }
    }
    
    
    // MARK: - TargetContentOffset

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let layoutAttributes = self.layoutAttributesForElements(in: collectionView!.bounds)
        
        let center = collectionView!.bounds.size.width / 2
        let proposedContentOffsetCenterOrigin = proposedContentOffset.x + center
        
        let closest = layoutAttributes!.sorted { 
            abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin)
        }.first ?? UICollectionViewLayoutAttributes()
        
        let targetContentOffset = CGPoint(x: floor(closest.center.x - center), y: proposedContentOffset.y)
        
        return targetContentOffset
    }
    
    
    // MARK: - Setup Methods

    private func setupCollectionView() {
        self.collectionView!.decelerationRate = UIScrollView.DecelerationRate.fast
        let collectionSize = collectionView!.bounds.size
        let itemWidth = collectionSize.width - sectionInsets.left * 2.0 - itemSpacing
        
        self.sectionInset = UIEdgeInsets(top: 0, 
                                         left: sectionInsets.left,
                                         bottom: 0, 
                                         right: sectionInsets.right)
        
        self.itemSize = CGSize(width: itemWidth, height: collectionSize.height)
        self.minimumLineSpacing = itemSpacing
        self.scrollDirection = .horizontal
        self.collectionView!.decelerationRate = UIScrollView.DecelerationRate.fast
    }
}
