//
//  CollectionCell.swift
//  Seriyal-2
//
//  Created by Zsolt Nagy on 2017. 11. 12..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import UIKit
import UIImageColors


class CollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var collectionCard: UIView!
    @IBOutlet weak var showCover: UIImageView!
    @IBOutlet weak var showTitle: UILabel!
    
    @IBOutlet weak var collectionImage: UIImageView!
    @IBOutlet weak var collectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cornerRadius: CGFloat = 2
        
        collectionCard.layer.cornerRadius = cornerRadius
        collectionCard.layer.shadowColor = UIColor.black.cgColor
        collectionCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        collectionCard.layer.shadowOpacity = 0.6
        collectionCard.layer.shadowRadius = 4
        
        collectionImage.layer.cornerRadius = cornerRadius
        collectionImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    
}
