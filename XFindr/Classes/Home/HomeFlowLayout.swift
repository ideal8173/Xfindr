//
//  HomeFlowLayout.swift
//  XFindr
//
//  Created by Rajat on 3/23/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class HomeListFlowLayout: UICollectionViewFlowLayout {
    
    let itemHeight: CGFloat = 116
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1.0
        minimumLineSpacing = 1.0
        scrollDirection = .vertical
    }
    
    func itemWidth() -> CGFloat {
        if let cv = collectionView {
            return cv.frame.size.width - 1.0
        }
        return 0.0
    }
    
    override var itemSize: CGSize {
        get {
            return CGSize(width: itemWidth(), height: itemHeight)
        } set {
            self.itemSize = CGSize(width: itemWidth(), height: itemHeight)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if let cv = collectionView {
            return cv.contentOffset
        }
        return CGPoint(x: 0.0, y: 0.0)
    }
}

class HomeGridFlowLayout: UICollectionViewFlowLayout {
    
    let itemHeight: CGFloat = 150
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 2.0
        minimumLineSpacing = 2.0
        scrollDirection = .vertical
    }
    
    func itemWidth() -> CGFloat {
        if let cv = collectionView {
            var widht: CGFloat = 0.0
            if ScreenSize.width == 320.0 {
                widht = (cv.frame.size.width / 2) - 1.0
            } else {
                widht = (cv.frame.size.width / 3) - (4.0 / 3.0)
            }
            return widht
        }
        return ScreenSize.width
    }
    
    override var itemSize: CGSize {
        get {
            let width = itemWidth()
            return CGSize(width: width, height: width)
        } set {
            let width = itemWidth()
            self.itemSize = CGSize(width: width, height: width)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if let cv = collectionView {
            return cv.contentOffset
        }
        return CGPoint(x: 0.0, y: 0.0)
    }
}
