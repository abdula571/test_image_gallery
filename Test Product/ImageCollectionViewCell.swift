//
//  ImageCollectionViewCell.swift
//  Test Product
//
//  Created by Abdula Magomedov on 09.02.2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    func setImageFrom(url: URL) {
        
        imageView.sd_setImage(with: url) { (image, _, _, _) in
            
            guard let image = image else { return }
            
            self.imageWidthConstraint.constant = self.bounds.width
            self.imageHeightConstraint.constant = max(self.bounds.height, (image.size.height / image.size.width) * self.bounds.width)
        }
    }
}
