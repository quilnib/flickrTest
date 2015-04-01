//
//  PhotoCell.swift
//  FlickrTest
//
//  Created by Tim Walsh on 3/31/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var imageView: UIImageView?
    var photo: NSDictionary?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView()
        self.contentView.addSubview(self.imageView!)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView!.frame = self.contentView.bounds
    }
    
    func setPhoto(photoDictionary: NSDictionary) {
        
        self.photo = photoDictionary
        
        var url: NSURL = FlickrKit.sharedFlickrKit().photoURLForSize(FKPhotoSizeLargeSquare150, fromPhotoDictionary: photoDictionary)
        
                
        PhotoController.imageForURL(url, size: "LargeSquare150") { (image) -> Void in
            self.imageView!.image = image
        }
        
    }
    
    //keeps the collectionView from flashing the old images when scrolling quickly
    override func prepareForReuse() {
        self.imageView?.image = UIImage()
    }

    
}
