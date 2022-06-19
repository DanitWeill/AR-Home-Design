//
//  SofaCollectionViewCell.swift
//  AR Home Design
//
//  Created by Danit on 19/06/2022.
//

import UIKit

class SofaCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var addRemoveLabel: UILabel!
    
    static let identifier = "SofaCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    public func configure(imageCell: UIImage, addRemoveBool: Bool) {
        
        imageView.image = imageCell

        if addRemoveBool == false{
            addRemoveLabel.text = "add"
        }else{
            addRemoveLabel.text = "remove"
        }
        
    }
    
    static func nib() -> UINib {
        return UINib (nibName: "SofaCollectionViewCell", bundle: nil)
    }

    
  
}
