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
    
    // we still need to set the photo, but this will have to change a bit
    func setPhoto(photoDictionary: NSDictionary) {
        
        self.photo = photoDictionary
        
        var url: NSURL = FlickrKit.sharedFlickrKit().photoURLForSize(FKPhotoSizeLargeSquare150, fromPhotoDictionary: photoDictionary)
        
                
        PhotoController.imageForURL(url, size: "LargeSquare150") { (image) -> Void in
            self.imageView!.image = image
        }
        
    }

    
}
