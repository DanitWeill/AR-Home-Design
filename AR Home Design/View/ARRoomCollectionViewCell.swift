//
//  ARRoomCollectionViewCell.swift
//  AR Home Design
//
//  Created by Danit on 19/06/2022.
//

import UIKit

class ARRoomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var chosenImageInCell: UIImageView!
    @IBOutlet weak var circleBackground: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    
    public func configure(imageCell: UIImage) {
        chosenImageInCell.image = imageCell
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ARRoomCollectionViewCell", bundle: nil)
    }
}


