//
//  CalendarFlowLayout.swift
//  Watcher
//
//  Created by Петр Первухин on 01/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class CalendarFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Private Properties
    
    private var isSetup = false
    private let itemSpacing: CGFloat = 0
    
    
    // MARK: - Prepare
    
    override func prepare() {
        super.prepare() 
        if isSetup == false {
            setupCollectionView()
            isSetup = true
        }
    }
    
    
    // MARK: - Setup Methods
    
    func setupCollectionView() {
        let collectionSize = collectionView!.frame.size
        let itemWidth = collectionSize.width / 7
        let itemHeight = collectionSize.height / 5.5
        
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.minimumLineSpacing = itemSpacing
        self.minimumInteritemSpacing = itemSpacing
    }
    
}
